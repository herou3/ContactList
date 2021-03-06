//
//  SoundPickerViewModel.swift
//  Contact List
//
//  Created by Pavel Kurilov on 04.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation

protocol SoundPickerViewModelDelegate: class {
    
    func soundPickerViewModel(_ viewModel: SoundPickerViewModel, didSaveChosenSound soundValue: String)
}

class SoundPickerViewModel: SoundPickerViewModelProtocol {
    
    // MARK: - Properies
    weak var delegate: SoundPickerViewModelDelegate?
    private let soundArray: [String?] = ["Die Mother Fucker, Die",
                                        "Papaoutai",
                                        "My Favourite Game",
                                        "ツワモノドモガ ユメノアト",
                                        "The Man Who Sold The World",
                                        "Old Yellow Bricks",
                                        "ツワモノドモガ ユメノアト",
                                        "The Man Who Sold The World",
                                        "Old Yellow Bricks"]
    var numberOfRows: Int {
        return soundArray.count
    }
    
    // MARK: - MARK: - SoundPickerViewModelProtocol methods
    func soundValue(forRow row: Int) -> String? {
        if row < soundArray.count && row >= 0 {
            return soundArray[row]
        } else {
            return "default value"
        }
    }
    
    func saveSoundValue(_ soundValue: String) {
        delegate?.soundPickerViewModel(self, didSaveChosenSound: soundValue)
    }
}
