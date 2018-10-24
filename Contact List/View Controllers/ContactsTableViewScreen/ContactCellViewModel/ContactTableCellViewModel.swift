//
//  ContactTableCellViewModel.swift
//  Contact List
//
//  Created by Pavel Kurilov on 19.08.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit

class ContactTableCellViewModel: ContactTableCellViewModelProtocol {
   
    // MARK: - Properies
    private var contact: Contact
   
    var fullName: String {
        
        guard let firstName = contact.firstName else { return "\(contact.lastName ?? "")" }
        guard let lastName = contact.lastName else { return "\(contact.firstName ?? "")"}
        return firstName + " " + lastName
    }
    
    var phoneNumber: String {
        let phoneNumber = contact.phoneNumber ?? " "
        return phoneNumber
    }
    
    var image: UIImage {
        let imageContact = UIImage(data: contact.image ?? Data()) ?? #imageLiteral(resourceName: "Portrait_placeholder")
        return imageContact
    }
    
    // MARK: - Init / deinit
    init(contact: Contact) {
        self.contact = contact
    }
}
