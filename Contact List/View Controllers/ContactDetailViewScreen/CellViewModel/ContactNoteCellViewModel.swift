//
//  ContactNoteCellViewModel.swift
//  Contact List
//
//  Created by Pavel Kurilov on 20.09.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation

class ContactNoteCellViewModel: ContactCellViewModelProtocol {
    
    // MARK: - Propertie
    var value: String?
    
    // MARK: - init / deinit
    init(value: String?) {
        self.configure(with: value)
    }
    
    // MARK: - Configure cell
    func configure(with value: String?) {
        guard let value = value else { return }
        self.value = value
    }
    
    // MARK: - bind to Detail view model
    func changeData(with text: String?) {
        self.value = text
    }
}
