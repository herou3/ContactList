//
//  ContactsListViewModel.swift
//  Contact List
//
//  Created by Pavel Kurilov on 19.08.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation
import RealmSwift

protocol ContactsListViewModelDelegate: class {
    
    func contactListViewModel(_ viewModel: ContactsListViewModel, didSelectContact contact: Contact)
    func contactListViewModelDidReqestSelectEmptyContact(_ viewModel: ContactsListViewModel)
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
    private var contactsList: [ContactsBySymbol] = []
    var realm: Realm
    private var contactsExample: [Contact]
    private var realmObjects: Results<RealmContact>!
    private var selectedIndexPath: IndexPath?
    private var indexTitles = [String]()
    private var realmWrapper = RealmWrapper()
    
    init() {
        realm = Realm.persistentStore()
        contactsExample = [Contact(firstName: "Pavel",
                                 lastName: "Kurilov",
                                 phoneNumber: "924186",
                                 image: UIImagePNGRepresentation(#imageLiteral(resourceName: "sova")),
                                 note: "Continue",
                                 sound: "fasf",
                                 id: UUID().uuidString),
                         Contact(firstName: "User",
                                 lastName: "Test",
                                 phoneNumber: "355",
                                 image: UIImagePNGRepresentation(#imageLiteral(resourceName: "sova")),
                                 note: "Test",
                                 sound: "Sound",
                                 id: UUID().uuidString),
                         Contact(firstName: "Corn",
                                 lastName: "Track",
                                 phoneNumber: "355",
                                 image: UIImagePNGRepresentation(#imageLiteral(resourceName: "sova")),
                                 note: "Test",
                                 sound: "Sound",
                                 id: UUID().uuidString)]
        
        if realm.objects(RealmContact.self).isEmpty {
            for contact in contactsExample {
                realmWrapper.saveObject(object: contact)
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
        let valueString = contactsList[section].contacts
        return valueString.count
    }
    
    func numberOfSections() -> Int {
        
        return contactsList.count
    }
    
    func getIndexTitles() -> [String] {
        
        return self.indexTitles
    }
    
    func titleForHeader(InSection section: Int) -> String {
        
        return String(describing: contactsList[section].symbol)
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> ContactTableCellViewModelProtocol? {
        
        return ContactTableCellViewModel(contact: contactsList[indexPath.section].contacts[indexPath.row])
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        delegate?.contactListViewModel(self, didSelectContact: contactsList[indexPath.section].contacts[indexPath.row])
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        searchingContacts = contacts.filter({ contact -> Bool in
            let fullName: String? = (contact.firstName ?? "") + " " + (contact.lastName ?? "")
            
            guard let isLastNameContact = contact.lastName?.lowercased().contains(find:
                searchText.lowercased()) else { return false }
            guard let isFirstNameContact = contact.firstName?.lowercased().contains(find:
                searchText.lowercased()) else { return false }
            guard let isFullName = fullName?.lowercased().contains(find:
                searchText.lowercased()) else { return false }
            guard let isPhoneNumber = contact.phoneNumber?.lowercased().contains(find:
                searchText.lowercased()) else { return false }
            
            return isFirstNameContact || isLastNameContact || isFullName || isPhoneNumber
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
            realmWrapper.saveObject(object: newContact)
        } else {
            let index = contacts.index(where: {$0.id == newContact.id })
            guard let curentIndex = index else { return }
            contacts[curentIndex] = newContact
            for obj in realm.objects(RealmContact.self) where obj.id == contacts[curentIndex].id {
                realmWrapper.saveObject(object: self.contacts[curentIndex])
            }
        }
    }
    
    func deleteContact(contact: Contact?) {
        guard let contact = contact else { return }
        let index = contacts.index(where: {$0.id == contact.id })
        guard let curentIndex = index else { return }
        for obj in realm.objects(RealmContact.self) where obj.id == contacts[curentIndex].id {
            realmWrapper.deleteObject(object: obj.transient())
        }
        contacts.remove(at: curentIndex)
    }
    
    func showNewContactViewController() {
        delegate?.contactListViewModelDidReqestSelectEmptyContact(self)
    }
    
    private func makeDataSource(contacts: [Contact]) {
        var contactsByCharacters = [ContactsBySymbol]()
        self.indexTitles = []
        guard contacts.count - 1 >= 0 else {
            self.contactsList = []
            return
        }
        for numberContact in 0...contacts.count-1 {
            let symbolOfContact: Character
            symbolOfContact = contacts[numberContact].lastName?.first ?? "#"
            let numberElementInContactsByCharacters = numberOfComprise(isComprise: contactsByCharacters, symbol: symbolOfContact)
            guard let numberValue = numberElementInContactsByCharacters else {
                contactsByCharacters.append(ContactsBySymbol(symbol: symbolOfContact, contacts: []))
                self.indexTitles.append(String(describing: symbolOfContact))
                let numberNewElement = contactsByCharacters.count - 1
                contactsByCharacters[numberNewElement].contacts.append(contacts[numberContact])
                continue
            }
            contactsByCharacters[numberValue].contacts.append(contacts[numberContact])
            contactsByCharacters[numberValue].contacts =
                contactsByCharacters[numberValue].contacts.sorted(by: { (contactFirst, contactSecond) -> Bool in
                let valueOne = contactFirst.lastName ?? "#Undefined"
                let valueTwo = contactSecond.lastName ?? "#Undefined"
                if valueOne < valueTwo {
                    return true
                } else {
                    return false
                }
            })
        }
            contactsByCharacters = contactsByCharacters.sorted { (symbolFirst, symbolSecond) -> Bool in
            let valueOne = symbolFirst.symbol
            let valueTwo = symbolSecond.symbol
            if valueOne > valueTwo {
                return true
            } else {
                return false
            }
        }
        contactsList = contactsByCharacters
    }
    
    private func numberOfComprise(isComprise contactsBySymbol: [ContactsBySymbol], symbol: Character) -> Int? {
        guard !contactsBySymbol.isEmpty else { return nil }
        guard contactsBySymbol.count - 1 >= 0 else { return nil }
        for number in 0...contactsBySymbol.count - 1 where symbol == contactsBySymbol[number].symbol {
            return number
        }
        return nil
    }
}
