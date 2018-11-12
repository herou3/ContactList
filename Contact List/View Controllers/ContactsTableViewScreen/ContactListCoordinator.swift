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
    private var changeSoundValueBlock: ((_ text: String) -> Void)?
    private var changeContactBlock: ((_ contact: Contact?) -> Void)?
    private var deleteContactBlock: ((_ contact: Contact?) -> Void)?
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.barTintColor = .silver
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func start() {
        showContactList()
    }
    
    // MARK: - Private implementation
    private func showContactList() {
        let contactsViewModel = ContactsListViewModel()
        contactsViewModel.delegate = self
        let controller = ContactsListController(viewModel: contactsViewModel)
        self.changeContactBlock = { data in
            contactsViewModel.updateContacts(newContact: data)
            self.navigationController?.popToRootViewController(animated: true)
        }
        self.deleteContactBlock = { data in
            contactsViewModel.deleteContact(contact: data)
            self.navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(controller, animated: false)
        controller.navigationItem.rightBarButtonItem = controller.barButtonItem(buttonType: .add)
        controller.navigationItem.title = "Contact List"
    }
    
    private func showDetailContact(_ contact: Contact) {
        let viewModel = ContactDetailViewModel(contact: contact)
        let detailController = ContactDetailController(viewModel: viewModel)
        viewModel.delegate = self
        self.changeSoundValueBlock = { data in
            viewModel.sound = data
        }
        detailController.navigationItem.title = viewModel.contactName()
        detailController.navigationItem.rightBarButtonItem = detailController.barButtonItem(buttonType: .done)
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    private func showDetailEmptyContact() {
        let emptyDetailEmptyViewModel = ContactDetailViewModel(contact: Contact())
        let detailController = ContactDetailController(viewModel: emptyDetailEmptyViewModel)
        emptyDetailEmptyViewModel.delegate = self
        self.changeSoundValueBlock = { data in
            emptyDetailEmptyViewModel.sound = data
        }
        detailController.navigationItem.rightBarButtonItem = detailController.barButtonItem(buttonType: .done)
        detailController.navigationItem.title = "New Contact"
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    private func showSoundPickerController() {
        let soundViewModel = SoundPickerViewModel()
        soundViewModel.delegate = self
        let soundController = SoundPickerController(viewModel: soundViewModel)
        let navController = UINavigationController(rootViewController: soundController)
        
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        soundController.navigationController?.navigationBar.barTintColor = .silver
        soundController.navigationController?.navigationBar.shadowImage = UIImage()
        soundController.navigationController?.navigationBar.tintColor = .black
        soundController.navigationController?.navigationBar.titleTextAttributes = textAttributes
        soundController.navigationItem.title = "Choose Sound"
        soundController.navigationItem.rightBarButtonItem = soundController.barButtonItem(type: .done)
        soundController.navigationItem.leftBarButtonItem = soundController.barButtonItem(type: .close)
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    private func dismissSoundPickerController(soundValue: String) {
        changeSoundValueBlock?(soundValue)
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension ContactsListViewModelDelegate
extension ContactsListCoordinator: ContactsListViewModelDelegate {
    
    func contactListViewModelDidReqestSelectEmptyContact(_ viewModel: ContactsListViewModel) {
        showDetailEmptyContact()
    }

    func contactListViewModel(_ viewModel: ContactsListViewModel, didSelectContact contact: Contact) {
        showDetailContact(contact)
    }
}

// MARK: - Extension ContactDetailViewModelDelegate
extension ContactsListCoordinator: ContactDetailViewModelDelegate {
    
    func contactDetailViewModel(_ viewModel: ContactDetailViewModel, didSaveContact contact: Contact?) {
        changeContactBlock?(contact)
    }
    
    func contactDetailViewModel(_ viewModel: ContactDetailViewModel, didDeleteContact contact: Contact?) {
        deleteContactBlock?(contact)
    }
    
    func contactDetailViewModelDidReqestShowSoundPicker(_ viewMidel: ContactDetailViewModel) {
        showSoundPickerController()
    }
}

// MARK: - Extension SoundPickerViewModelDelegate
extension ContactsListCoordinator: SoundPickerViewModelDelegate {
    
    func soundPickerViewModel(_ viewModel: SoundPickerViewModel, didSaveChosenSound soundValue: String) {
        dismissSoundPickerController(soundValue: soundValue)
    }
}
