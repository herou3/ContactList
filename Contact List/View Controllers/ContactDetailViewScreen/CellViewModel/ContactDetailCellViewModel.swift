//
//  ContactDetailCellViewModel.swift
//  Contact List

import Foundation

class ContactDetailCellViewModel: ContactCellViewModelProtocol {
    
    // MARK: - Propertie
    var value: String?
    var typeCell: TypeCell?
    var requestTapBlock: (() -> Void)?
    
    // MARK: - init / deinit
    init(value: String?, typeCell: TypeCell) {
        self.typeCell = typeCell
        self.configure(with: value)
    }
    
    // MARK: - Configure cell
    internal func configure(with value: String?) {
        guard let value = value else { return }
        switch self.typeCell {
        case .lastName?:
            self.value = value
        case .name?:
            self.value = value
        default:
            self.value = value
        }
    }
    
    // MARK: - bind to Detail view model
    func changeData(with text: String?) {
        self.value = text
    }
    
    func requestTapReturnAction() {
        requestTapBlock?()
    }
}
