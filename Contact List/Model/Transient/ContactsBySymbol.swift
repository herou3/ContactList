//
//  ContactList.swift
//  Contact List
//
//  Created by Pavel Kurilov on 25.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation

struct ContactsBySymbol {
    
    // MARK: - Properties
    var symbol: Character
    var contacts: [Contact]
    
    init(symbol: Character, contacts: [Contact]) {
        self.symbol = symbol
        self.contacts = contacts
    }
}
