//
//  SongPickerViewModelProtocol.swift
//  Contact List
//
//  Created by Pavel Kurilov on 08.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation

protocol SongPickerViewModelProtocol: class {
 
    func numberOfRows() -> Int
    
    func songValue(forRow row: Int) -> String?
    
    func saveSongValue(_ songValue: String)
}
