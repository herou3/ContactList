//
//  ContactsListViewModel.swift
//  Contact List
//
//  Created by Pavel Kurilov on 19.08.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation

class ContactsListViewModel: ContactsListViewModelProtocol {
    
    // MARK: - Properies
    private let contacts: [Contact] = [Contact(firstName: "Pavel",
                                               secondName: "Kurilov",
                                               phoneNumber: "8 800 555-35-35",
                                               image: #imageLiteral(resourceName: "sova"),
                                               note: "I'm Batman",
                                               song: "HelloKitty.mp3"),
                                       Contact(firstName: "User",
                                               secondName: "Longer",
                                               phoneNumber: "8 915 650-25-90",
                                               image: #imageLiteral(resourceName: "sova"),
                                               note: "I'm Debil",
                                               song: "tree.mp4")]
    private var selectedIndexPath: IndexPath?
    
    func numberOfRows() -> Int {
        return contacts.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> ContactTableCellViewModelProtocol? {
        return ContactTableCellViewModel(contact: contacts[indexPath.row])
    }
    
    func viewModelForSelectedRow() -> ContactDetailViewModelProtocol? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        return ContactDetailViewModel(contact: contacts[selectedIndexPath.row])
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
}
