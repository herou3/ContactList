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
    var deleteTap: (() -> Void)?
    
    // MARK: - Init / Deinit
    init(value: AnyObject, deleteAction: @escaping (() -> Void)) {
        self.configure(with: value)
        self.deleteTap = deleteAction
    }
    
    // MARK: - Methods ContactCellViewModelProtocol
    func changeData(with text: String?) { }
    
    func configure(with value: AnyObject) {
        self.value = "Delete Contact"
    }
    
    // MARK: - Internal Methods
    func deleteAction() {
        self.deleteTap?()
    }
}
