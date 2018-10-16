//
//  ContactSongCellViewModel.swift
//  Contact List
//
//  Created by Pavel Kurilov on 20.09.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation

class ContactSongCellViewModel: ContactCellViewModelProtocol {
    
    // MARK: - Propertie
    var value: String?
    var changeSong: ((_ text: String?) -> Void)?
    
    // MARK: - init / deinit
    init(value: AnyObject, changeData: @escaping ((_ text: String?) -> Void)) {
        self.configure(with: value)
        changeSong = changeData
    }
    
    // MARK: - Configure cell
    func configure(with value: AnyObject) {
        guard let value = value as? String else { return }
        self.value = value
    }
    
    // MARK: - Change data use text
    func changeData(with text: String?) {
        self.value = text
    }
    
    func requestAction() {
        self.changeSong?("test")
    }
}
