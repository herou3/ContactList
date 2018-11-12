//
//  ContactDetailViewModel.swift
//  Contact List

import UIKit

protocol ContactDetailViewModelDelegate: class {
    
    func contactDetailViewModelDidReqestShowSoundPicker(_ viewMidel: ContactDetailViewModel)
    func contactDetailViewModel(_ viewModel: ContactDetailViewModel, didSaveContact contact: Contact?)
    func contactDetailViewModel(_ viewModel: ContactDetailViewModel, didDeleteContact contact: Contact?)
}

enum StandartCellType {
    case name, lastName, phone
    
    var description: String {
        switch self {
        case .name:
            return "First Name"
        case .lastName:
            return "Last Name"
        case .phone:
            return "Phone number"
        }
    }
}

enum CellType: Int {
    case nameCell, lastNameCell, phoneCell, noteCell, soundCell, deleteCell
}

class ContactDetailViewModel: ContactDetailViewModelProtocol {
    
    // MARK: - Propertiies
    private var contact: Contact?
    private var newContactCellsViewModel: [ContactCellViewModelProtocol] = []
    weak var delegate: ContactDetailViewModelDelegate?
    
    private var onDidUpdateDataSourceBlock: (() -> Void)?
    private var onDidUpdateSoundNameBlock: ((_ value: String?) -> Void)?
    var onDidUpdateImageBlock: ((_ value: UIImage?) -> Void)?
    var onDidChangeSoundValueBlock: (() -> Void)?
    var onDidRequestOfDeleteBlock: (() -> Void)?
    var onDidRequestTapBlock: ((_ nextNumberCell: Int) -> Void)?
    
    var firstName: String?
    var lastName: String?
    var phone: String?
    var sound: String?
    var note: String?
    var image: UIImage?
    
    var numberOfRows: Int {
        return newContactCellsViewModel.count
    }
    
    // MARK: - init / deinit
    init(contact: Contact?) {
        self.contact = contact
        self.firstName = contact?.firstName
        self.lastName = contact?.lastName
        self.phone = contact?.phoneNumber
        self.note = contact?.note
        self.sound = contact?.sound
        self.image = UIImage(data: contact?.image ?? Data())
        makeCellsViewModel()
    }
    
    // MARK: - Make cells view model
    private func makeCellsViewModel() {
        // for internal methods
        let firstNameCellViewModel = ContactDetailCellViewModel(value: self.firstName, cellType: .name)
        let lastNameCellViewModel = ContactDetailCellViewModel(value: self.lastName, cellType: .lastName)
        let phoneCellViewModel = ContactDetailCellViewModel(value: self.phone, cellType: .phone)
        let soundCellViewModel = ContactSoundCellViewModel(value: self.sound)
        
        soundCellViewModel.onDidChangedSoundState = { [unowned self] in
            self.changeSound()
        }
        
        let noteCellViewModel = ContactNoteCellViewModel(value: self.note)
        let deleteContactCellViewModel = ContactDeleteCellViewModel(value: "Delete Contact")
        
        deleteContactCellViewModel.deleteRequestBlock = { [unowned self] in
            self.deleteContact()
        }
        
        newContactCellsViewModel.append(firstNameCellViewModel)
        newContactCellsViewModel.append(lastNameCellViewModel)
        newContactCellsViewModel.append(phoneCellViewModel)
        newContactCellsViewModel.append(noteCellViewModel)
        newContactCellsViewModel.append(soundCellViewModel)
        if self.contact?.id != nil {
            newContactCellsViewModel.append(deleteContactCellViewModel)
        }
        
        for value in (0...newContactCellsViewModel.count) {
            guard let detailViewModel = newContactCellsViewModel[value] as? ContactDetailCellViewModel else { break }
            detailViewModel.onDidTapReturnButton = { [] in
                let nextValue = value + 1
                self.onDidRequestTapBlock?(nextValue)
            }
        }
        
        onDidUpdateDataSourceBlock = { [unowned self] in
            self.firstName = firstNameCellViewModel.value
            self.lastName = lastNameCellViewModel.value
            self.phone = phoneCellViewModel.value
            self.note = noteCellViewModel.value
        }
        
        onDidUpdateSoundNameBlock = { [unowned self] value in
            self.sound = value
            soundCellViewModel.value = self.sound
        }
        
        onDidUpdateImageBlock = { [unowned self] value in
            self.image = value
        }
        
        onDidChangeSoundValueBlock = { [unowned self] in
            self.delegate?.contactDetailViewModelDidReqestShowSoundPicker(self)
        }
    }
    
    // MARK: - Methods ContactDetailViewModelProtocol
    func detailCellViewModel(forIndexPath indexPath: IndexPath) -> ContactCellViewModelProtocol? {
        return newContactCellsViewModel[indexPath.row]
    }
    
    func saveContact() {
        onDidUpdateDataSourceBlock?()
        delegate?.contactDetailViewModel(self, didSaveContact: self.updateContact())
    }
    
    func contactName() -> String {
        guard let firstName = firstName else { return "No name" }
        return firstName
    }
    
    // MARK: - Bind to viewController
    func changeSound() {
        onDidChangeSoundValueBlock?()
    }
    
    func deleteContact() {
        onDidRequestOfDeleteBlock?()
    }
    
    func getRequestDelete() {
        delegate?.contactDetailViewModel(self, didDeleteContact: self.contact)
    }
    
    func updateSound(soundName: String?) {
        onDidUpdateSoundNameBlock?(soundName)
    }
    
    func updateContact() -> Contact? {
        self.contact?.firstName = self.firstName
        self.contact?.lastName = self.lastName
        self.contact?.phoneNumber = self.phone
        self.contact?.sound = self.sound
        self.contact?.note = self.note
        self.contact?.image = UIImagePNGRepresentation(self.image ?? #imageLiteral(resourceName: "Portrait_placeholder"))
        if contact?.id == nil {
            contact?.id =  UUID().uuidString
        }
        return self.contact
    }
}
