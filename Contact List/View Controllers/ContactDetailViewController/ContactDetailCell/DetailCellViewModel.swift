//
//  DetailCellViewModel.swift
//  Contact List

import Foundation

enum TypeCell {
    case name, lastName, phone, song, note
    
    var description: String {
        switch self {
        case .name:
            return "First Name"
        case .lastName:
            return "Last Name"
        case .phone:
            return "Phone number"
        case .song:
            return "Song"
        case .note:
            return "Note"
        }
    }
}

class DetailCellViewModel: NSObject {
    
    var value: String?
    var name: String?
    var lastName: String?
    var phone: String?
    var song: String?
    var note: String?
    var typeCell: TypeCell?
    
    func configure(with viewModel: ContactDetailViewModel) {
        switch self.typeCell {
        case .lastName?:
            self.lastName = viewModel.lastName
        case .name?:
            self.name = viewModel.name
        case .phone?:
            self.phone = viewModel.phone
        case .song?:
            self.song = viewModel.song
        default:
            self.note = viewModel.note
        }
    }
    
    init(viewModel: ContactDetailViewModel, typeCell: TypeCell) {
        super.init()
        self.typeCell = typeCell
        self.configure(with: viewModel)
    }
}
