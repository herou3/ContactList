//
//  Contact.swift
//  Contact List

import Foundation

struct Contact: TransientEntity {
    
    typealias RealmType = RealmContact
    
    // MARK: - Properties
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var image: Data?
    var note: String?
    var sound: String?
    var id: String?
}
