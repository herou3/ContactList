//
//  ContactDetailViewModel.swift
//  Contact List

import UIKit

class ContactDetailViewModel: ContactDetailViewModelProtocol {
    
    private var contact: Contact
    var newContactCellsViewModel: [DetailCellViewModel] = []
    
    var firstName = String()
    var lastName = String()
    var phone = String()
    var song = String()
    var note = String()
    
    var onDidRefreshData: (() -> Void)?
    var onDidUpdateFirstName: (() -> Void)?
    var onDidUpdateLastName: (() -> Void)?
    var onDidUpdatePhone: (() -> Void)?
    var onDidUpdateSong: (() -> Void)?
    var onDidUpdateNote: (() -> Void)?
    
    var age: String? {
        return String(describing: contact.song)
    }
    var image: UIImage? {
        return contact.image
    }
    var name: String? {
        let firstName = contact.firstName ?? " "
        let lastName = contact.secondName ?? " "
        return firstName + " " + lastName
    }
    
    private func configureCellsViewModel() {
        let firstNameCellViewModel = DetailCellViewModel(viewModel: self, typeCell: .name)
        let lastNameCellViewModel = DetailCellViewModel(viewModel: self, typeCell: .lastName)
        let phoneCellViewModel = DetailCellViewModel(viewModel: self, typeCell: .phone)
        let songCellViewModel = DetailCellViewModel(viewModel: self, typeCell: .song)
        let noteCellViewModel = DetailCellViewModel(viewModel: self, typeCell: .note)
        
        newContactCellsViewModel.append(firstNameCellViewModel)
        newContactCellsViewModel.append(lastNameCellViewModel)
        newContactCellsViewModel.append(phoneCellViewModel)
        newContactCellsViewModel.append(songCellViewModel)
        newContactCellsViewModel.append(noteCellViewModel)
    }
    
    init(contact: Contact) {
        self.contact = contact
        self.firstName = contact.firstName ?? ""
        self.lastName = contact.secondName ?? ""
        self.phone = contact.phoneNumber ?? ""
        self.song = contact.song ?? ""
        self.note = contact.note ?? ""
        configureCellsViewModel()
    }
    
    func numberOfRows() -> Int {
        return newContactCellsViewModel.count
    }
    
    func detailCellViewModel(forIndexPath indexPath: IndexPath) -> DetailCellViewModel? {
        return newContactCellsViewModel[indexPath.row]
    }
    
    // БУДУ БРАТЬ ЗНАЧЕНИЯ С ПОЛЕЙ firstNameCell и тд и подставлять в текущий контакт
}
