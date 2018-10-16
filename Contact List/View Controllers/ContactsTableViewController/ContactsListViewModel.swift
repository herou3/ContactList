//
//  ContactsListViewModel.swift
//  Contact List
//
//  Created by Pavel Kurilov on 19.08.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation
import RealmSwift

protocol  ContactsListViewModelDelegate: class {
    
    func contactListViewModel(_ viewModel: ContactsListViewModel, didSelectContact contact: Contact)
    func addContactAction()
}

class ContactsListViewModel: ContactsListViewModelProtocol {
    
    // MARK: - Properies
    weak var delegate: ContactsListViewModelDelegate?
    private var searchingContacts: [Contact] = [] {
        didSet {
            makeDataSource(contacts: searchingContacts)
        }
    }
    private var contacts: [Contact] = [] {
        didSet {
            searchingContacts = contacts
            makeDataSource(contacts: searchingContacts)
        }
    }
    let realm: Realm
    private var realmContacts: [RealmContact]
    private var realmObjects: Results<RealmContact>!
    private var selectedIndexPath: IndexPath?
    private var dictionaryOfContacts = [(String, [Contact])]()
    private var indexTitles = [String]()
    
    init() {
        realm = Realm.persistentStore()
        realmContacts = [RealmContact.from(transient: Contact(firstName: "Pavel",
                                                              lastName: "Kurilov",
                                                              phoneNumber: "924186",
                                                              image: UIImagePNGRepresentation(#imageLiteral(resourceName: "sova")),
                                                              note: "Continue",
                                                              song: "fasf",
                                                              id: UUID().uuidString), in: realm),
                         RealmContact.from(transient: Contact(firstName: "User",
                                                              lastName: "Test",
                                                              phoneNumber: "355",
                                                              image: UIImagePNGRepresentation(#imageLiteral(resourceName: "sova")),
                                                              note: "Test",
                                                              song: "Song",
                                                              id: UUID().uuidString), in: realm),
                         RealmContact.from(transient: Contact(firstName: "User",
                                                              lastName: "Test",
                                                              phoneNumber: "355",
                                                              image: UIImagePNGRepresentation(#imageLiteral(resourceName: "sova")),
                                                              note: "Test",
                                                              song: "Song",
                                                              id: UUID().uuidString), in: realm)]
        
        if realm.objects(RealmContact.self).count == 0 {
            for realmContact in realmContacts {
                try? realm.write {
                    realm.add(realmContact)
                }
            }
        }
        
        for obj in realm.objects(RealmContact.self) {
            let contact = obj.transient()
            contacts.append(contact)
        }
        
        searchingContacts = contacts
        self.makeDataSource(contacts: searchingContacts)
    }

    // MARK: - Protocols methods
    func numberOfRows(numberOfRowsInSection section: Int) -> Int {
        let valueString = dictionaryOfContacts[section].1
        return valueString.count
    }
    
    func numberOfSections() -> Int {
        return dictionaryOfContacts.count
    }
    
    func getIndexTitles() -> [String] {
        return self.indexTitles
    }
    
    func titleForHeader(InSection section: Int) -> String {
        return dictionaryOfContacts[section].0
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> ContactTableCellViewModelProtocol? {
        return ContactTableCellViewModel(contact: dictionaryOfContacts[indexPath.section].1[indexPath.row])
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        delegate?.contactListViewModel(self, didSelectContact: dictionaryOfContacts[indexPath.section].1[indexPath.row])
    }
    
    func filterContentForSearchText(_ searchText: String) {
        searchingContacts = contacts.filter({ contact -> Bool in
            guard let isLastNameContact = contact.lastName?.lowercased().contains(find:
                searchText.lowercased()) else { return false }
            return isLastNameContact
        })
    }
    
    func cancelSearchingProcess() {
        searchingContacts = contacts
    }
    
    // MARK: - Internal methods
    func updateContacts(newContact: Contact?) {
        guard let newContact = newContact else { return }
        if !(contacts.map { $0.id }.contains(newContact.id)) {
            contacts.append(newContact)
            try? realm.write {
                realm.add(RealmContact.from(transient: newContact, in: realm))
            }
        } else {
            let index = contacts.index(where: {$0.id == newContact.id })
            guard let curentIndex = index else { return }
            contacts[curentIndex] = newContact
            for obj in realm.objects(RealmContact.self) {
                if obj.id == contacts[curentIndex].id {
                    try? self.realm.write {
                        let realmContact = RealmContact.from(transient: contacts[curentIndex], in: realm)
                        self.realm.add(realmContact)
                    }
                }
            }
        }
    }
    
    func deleteContact(contact: Contact?) {
        guard let contact = contact else { return }
        let index = contacts.index(where: {$0.id == contact.id })
        guard let curentIndex = index else { return }
        for obj in realm.objects(RealmContact.self) {
            if obj.id == contacts[curentIndex].id {
                try? self.realm.write {
                    self.realm.delete(obj)
                }
            }
        }
        contacts.remove(at: curentIndex)
    }
    
    func showNewContactViewController() {
        delegate?.addContactAction()
    }
    
    private func makeDataSource(contacts: [Contact]) {
        
        var dictionary = [String: [Contact]]()
        let letters = NSCharacterSet.letters
        for contact in contacts {
            let value: Character
            value = contact.lastName?.first ?? "#"
            var key = String(describing: value)
            key = isKeyCharacter(key: key, letters: letters) ? key : "#"
            if let keyValue = dictionary[key] {
                var filteredValue = keyValue
                filteredValue.append(contact)
                filteredValue = filteredValue.sorted(by: { (contactFirst, contactSecond) -> Bool in
                    let valueOne = contactFirst.lastName ?? "#Undefined"
                    let valueTwo = contactSecond.lastName ?? "#Undefined"
                    if valueOne < valueTwo {
                        return true
                    } else {
                        return false
                    }
                })
                dictionary[key] = filteredValue
            } else {
                let filtered = [contact]
                dictionary[key] = filtered
            }
        }
        self.dictionaryOfContacts = Array(dictionary).sorted {$0.0 < $1.0}
        self.indexTitles = Array(dictionary.keys.sorted(by: <))
        
        if !self.dictionaryOfContacts.isEmpty {
            let temp = self.dictionaryOfContacts[0]
            self.dictionaryOfContacts.removeFirst()
            self.dictionaryOfContacts.append(temp)
        }
        
        if !self.dictionaryOfContacts.isEmpty {
            let tempIndex = self.indexTitles[0]
            self.indexTitles.removeFirst()
            self.indexTitles.append(tempIndex)
        }
    }
    
    private func isKeyCharacter(key: String, letters: CharacterSet) -> Bool {
        let range = key.rangeOfCharacter(from: letters)
        if var _ = range {
            //Your key is an alphabet
            return true
        }
        return false
    }

}
