//
//  SoundPickerViewModelProtocol.swift
//  Contact List
//
//  Created by Pavel Kurilov on 08.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation

protocol SoundPickerViewModelProtocol: class {
 
    var numberOfRows: Int { get }
    
    func soundValue(forRow row: Int) -> String?
    
    func saveSoundValue(_ soundValue: String)
}
