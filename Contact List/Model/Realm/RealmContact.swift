//
//  RealmContact.swift
//  Contact List
//
//  Created by Pavel Kurilov on 30.08.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmContact: Object {
    
    // MARK: - Properties
    typealias TransientType = Constant
    private static let taskPrimaryKey = "id"

    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var phoneNumber: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var note: String?
    @objc dynamic var sound: String?
    @objc dynamic var id: String = ""
    
    // MARK: - Methods
    
    override class func primaryKey() -> String? {
        return taskPrimaryKey
    }
    
    // MARK: - Realm transform
    static func from(transient: Contact, in realm: Realm) -> RealmContact {
        
        let cached = realm.object(ofType: RealmContact.self, forPrimaryKey: transient.id)
        let realmContact: RealmContact
    
        if let cached = cached {
            realmContact = cached
        } else {
            realmContact = RealmContact()
            realmContact.id = transient.id ?? ""
        }
        
        realmContact.firstName = transient.firstName
        realmContact.lastName = transient.lastName
        realmContact.phoneNumber = transient.phoneNumber
        realmContact.imageData = transient.image
        realmContact.note = transient.note
        realmContact.sound = transient.sound
        
        return realmContact
    }
    
    func transient() -> Contact {
        
        var transient = Contact(firstName: "",
                                lastName: "",
                                phoneNumber: "",
                                image: Data(),
                                note: "",
                                sound: "",
                                id: UUID().uuidString)
        
        transient.firstName = firstName
        transient.lastName = lastName
        transient.phoneNumber = phoneNumber
        transient.note = note
        transient.sound = sound
        transient.id = id
        transient.image = imageData
        
        return transient
    }
    
}
