//
//  DetailCellViewModelProtocol.swift
//  Contact List
//
//  Created by Pavel Kurilov on 25.09.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation

protocol  ContactCellViewModelProtocol {
    
    var value: String? { get set}
    
    func configure(with value: String?)
}
