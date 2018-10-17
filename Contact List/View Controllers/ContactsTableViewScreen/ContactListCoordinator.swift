//
//  ContactListCoordinator.swift
//  Contact List
//
//  Created by Pavel Kurilov on 01.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit

protocol UpdateableWitchContactList: class {
    var contac: Contact? { get set }
}

final class ContactsListCoordinator {
    
    // MARK: - Properties
    private weak var navigationController: UINavigationController?
    private var changeSongValue: ((_ text: String) -> Void)?
    private var changeContact: ((_ contact: Contact?) -> Void)?
    private var deleteContact: ((_ contact: Contact?) -> Void)?
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showContactList()
    }
    
    // MARK: - Private implementation
    private func showContactList() {
        let contactsViewModel = ContactsListViewModel()
        contactsViewModel.delegate = self
        let controller = ContactsListController(viewModel: contactsViewModel)
        self.changeContact = { data in
            contactsViewModel.updateContacts(newContact: data)
            self.navigationController?.popToRootViewController(animated: true)
        }
        self.deleteContact = { data in
            contactsViewModel.deleteContact(contact: data)
            self.navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(controller, animated: false)
    }
    
    private func showDetailContact(_ contact: Contact) {
        let viewModel = ContactDetailViewModel(contact: contact)
        let controller = ContactDetailController(viewModel: viewModel)
        viewModel.delegate = self
        self.changeSongValue = { data in
            viewModel.song = data
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showDetailEmptyContact() {
        let emptyDetailEmptyViewModel = ContactDetailViewModel(contact: Contact())
        let controller = ContactDetailController(viewModel: emptyDetailEmptyViewModel)
        emptyDetailEmptyViewModel.delegate = self
        self.changeSongValue = { data in
            emptyDetailEmptyViewModel.song = data
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showSongPickerController() {
        let songViewModel = SongPickerViewModel()
        songViewModel.delegate = self
        let songController = SongPickerController(viewModel: songViewModel)
        let navController = UINavigationController(rootViewController: songController)
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    private func dismissSongPickerController(songValue: String) {
        changeSongValue?(songValue)
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension ContactsListViewModelDelegate
extension ContactsListCoordinator: ContactsListViewModelDelegate {
    
    func addContactAction() {
        showDetailEmptyContact()
    }
    
    func contactListViewModel(_ viewModel: ContactsListViewModel, didSelectContact contact: Contact) {
        showDetailContact(contact)
    }
}

// MARK: - Extension ContactDetailViewModelDelegate
extension ContactsListCoordinator: ContactDetailViewModelDelegate {
    
    func deleteContact(_ contact: Contact?) {
        deleteContact?(contact)
    }
    
    func getContact(_ contact: Contact?) {
        changeContact?(contact)
    }
    
    func songPickerViewModel() {
        showSongPickerController()
    }
}

// MARK: - Extension SongPickerViewModelDelegate
extension ContactsListCoordinator: SongPickerViewModelDelegate {
    
    func saveChoisedSong(valueSong: String) {
        dismissSongPickerController(songValue: valueSong)
    }
}
