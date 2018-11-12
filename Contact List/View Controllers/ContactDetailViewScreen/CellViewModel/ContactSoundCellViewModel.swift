//
//  ContactSoundCellViewModel.swift
//  Contact List
//
//  Created by Pavel Kurilov on 20.09.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation

class ContactSoundCellViewModel: ContactCellViewModelProtocol {
    
    // MARK: - Propertie
    var value: String?
    var onDidChangedSoundState: (() -> Void)?
    
    // MARK: - init / deinit
    init(value: String?) {
        self.configure(with: value)
    }
    
    // MARK: - Configure self
    func configure(with value: String?) {
        guard let value = value  else { return }
        self.value = value
    }
    
    // MARK: - Change data use text
    func requestShowSounds() {
        self.onDidChangedSoundState?()
    }
}
