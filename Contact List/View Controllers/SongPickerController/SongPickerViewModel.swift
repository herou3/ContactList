//
//  SongPickerViewModel.swift
//  Contact List
//
//  Created by Pavel Kurilov on 04.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation

protocol SongPickerViewModelDelegate: class {
    
    func saveChoisedSong(valueSong: String)
}

class SongPickerViewModel: SongPickerViewModelProtocol {
    
    // MARK: - Properies
    weak var delegate: SongPickerViewModelDelegate?
    private let songArray: [String?] = ["Die Mother Fucker, Die",
                                        "Papaoutai",
                                        "My Favourite Game",
                                        "ツワモノドモガ ユメノアト",
                                        "The Man Who Sold The World",
                                        "Old Yellow Bricks",
                                        "ツワモノドモガ ユメノアト",
                                        "The Man Who Sold The World",
                                        "Old Yellow Bricks"]
    
    // MARK: - MARK: - SongPickerViewModelProtocol methods
    func numberOfRows() -> Int {
        return songArray.count
    }
    
    func songValue(forRow row: Int) -> String? {
        return songArray[row]
    }
    
    func saveSongValue(_ songValue: String) {
        delegate?.saveChoisedSong(valueSong: songValue)
    }
}
