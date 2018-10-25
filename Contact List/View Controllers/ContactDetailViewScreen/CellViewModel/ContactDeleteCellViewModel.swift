//
//  ContactDeleteCellViewModel.swift
//  Contact List
//
//  Created by Pavel Kurilov on 10.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation

class ContactDeleteCellViewModel: ContactCellViewModelProtocol {
    
    // MARK: - Properties
    var value: String?
    var deleteRequestBlock: (() -> Void)?
    
    // MARK: - Init / Deinit
    init(value: String?) {
        self.configure(with: value)
        self.deleteRequestBlock = deleteAction
    }
    
    // MARK: - Methods ContactCellViewModelProtocol
    func changeData(with text: String?) { }
    
    func configure(with value: String?) {
        self.value = "Delete Contact"
    }
    
    // MARK: - Internal Methods
    func deleteAction() {
        self.deleteRequestBlock?()
    }
}
