//
//  ContactDetailViewModel.swift
//  Contact List

import UIKit

protocol ContactDetailViewModelDelegate: class {
    
    func songPickerViewModel()
    func getContact(_ contact: Contact?)
    func deleteContact(_ contact: Contact?)
}

enum TypeCell {
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

class ContactDetailViewModel: ContactDetailViewModelProtocol {
    
    // MARK: - Propertiies
    private var contact: Contact?
    private var newContactCellsViewModel: [ContactCellViewModelProtocol] = []
    weak var delegate: ContactDetailViewModelDelegate?
    
    private var updateData: (() -> Void)?
    private var updateSongName: ((_ value: String?) -> Void)?
    var updateImage: ((_ value: UIImage?) -> Void)?
    var changeSong: (() -> Void)?
    var deleteContact: (() -> Void)?
    
    var firstName: String?
    var lastName: String?
    var phone: String?
    var song: String?
    var note: String?
    var image: UIImage?
    
    // MARK: - init / deinit
    init(contact: Contact?) {
        self.contact = contact
        self.firstName = contact?.firstName
        self.lastName = contact?.lastName
        self.phone = contact?.phoneNumber
        self.note = contact?.note
        self.song = contact?.song
        self.image = UIImage(data: contact?.image ?? Data())
        makeCellsViewModel()
    }
    
    // MARK: - Make cells view model
    private func makeCellsViewModel() {
        // for internal methods
        let changingData: (String?) -> Void = { [unowned self] data in
            self.onDidChangeSongValue()
        }
        let deleteContact: () -> Void = { [unowned self] in
            self.onDidRequestOfDelete()
        }
        
        let firstNameCellViewModel = ContactDetailCellViewModel(value: self.firstName as AnyObject, typeCell: .name)
        let lastNameCellViewModel = ContactDetailCellViewModel(value: self.lastName as AnyObject, typeCell: .lastName)
        let phoneCellViewModel = ContactDetailCellViewModel(value: self.phone as AnyObject, typeCell: .phone)
        let songCellViewModel = ContactSongCellViewModel(value: self.song as AnyObject, changeData: changingData)
        let noteCellViewModel = ContactNoteCellViewModel(value: self.note as AnyObject)
        let deleteContactCellViewModel = ContactDeleteCellViewModel(value: "Delete Contact" as AnyObject,
                                                                 deleteAction: deleteContact)
        firstNameCellViewModel.requestTapReturn = { [] in
            lastNameCellViewModel.selectTextField()
        }
        lastNameCellViewModel.requestTapReturn = { [] in
            phoneCellViewModel.selectTextField()
        }
        phoneCellViewModel.requestTapReturn = { [] in
            noteCellViewModel.selectTextView()
        }
        
        newContactCellsViewModel.append(firstNameCellViewModel)
        newContactCellsViewModel.append(lastNameCellViewModel)
        newContactCellsViewModel.append(phoneCellViewModel)
        newContactCellsViewModel.append(noteCellViewModel)
        newContactCellsViewModel.append(songCellViewModel)
        if self.contact?.id != nil {
            newContactCellsViewModel.append(deleteContactCellViewModel)
        }
        
        updateData = { [unowned self] in
            self.firstName = firstNameCellViewModel.value
            self.lastName = lastNameCellViewModel.value
            self.phone = phoneCellViewModel.value
            self.note = noteCellViewModel.value
        }
        
        updateSongName = { [unowned self] value in
            self.song = value
            songCellViewModel.value = self.song
        }
        
        updateImage = { [unowned self] value in
            self.image = value
        }
    }
    
    // MARK: - Methods ContactDetailViewModelProtocol
    func numberOfRows() -> Int {
        return newContactCellsViewModel.count
    }
    
    func detailCellViewModel(forIndexPath indexPath: IndexPath) -> ContactCellViewModelProtocol? {
        return newContactCellsViewModel[indexPath.row]
    }
    
    func saveContact() {
        updateData?()
        delegate?.getContact(self.updateContact())
    }
    
    // MARK: - Bind to viewController
    func onDidChangeSongValue() {
        changeSong?()
    }
    
    func onDidRequestOfDelete() {
        deleteContact?()
    }
    
    func onDidGetRequestDelete() {
        delegate?.deleteContact(self.contact)
    }
    
    func onDidShowPicker() {
        delegate?.songPickerViewModel()
    }
    
    func onDidUpdateSong(songName: String?) {
        updateSongName?(songName)
    }
    
    func updateContact() -> Contact? {
        self.contact?.firstName = self.firstName
        self.contact?.lastName = self.lastName
        self.contact?.phoneNumber = self.phone
        self.contact?.song = self.song
        self.contact?.note = self.note
        self.contact?.image = UIImagePNGRepresentation(self.image ?? #imageLiteral(resourceName: "Portrait_placeholder"))
        if contact?.id == nil {
            contact?.id =  UUID().uuidString
        }
        return self.contact
    }
}
