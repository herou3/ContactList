//
//  ContactTableCellViewModel.swift
//  Contact List
//
//  Created by Pavel Kurilov on 19.08.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit

class ContactTableCellViewModel: ContactTableCellViewModelProtocol {
   
    var value: String?
    
    private var contact: Contact
   
    var fullName: String {
        let firstName = contact.firstName ?? " "
        let lastName = contact.secondName ?? " "
        return firstName + " " + lastName
    }
    
    var phoneNumber: String {
        let phoneNumber = contact.phoneNumber ?? " "
        return phoneNumber
    }
    
    var image: UIImage {
        let imageContact = contact.image ?? #imageLiteral(resourceName: "Portrait_placeholder")
        return imageContact
    }
    
    init(contact: Contact) {
        self.contact = contact
    }
}
