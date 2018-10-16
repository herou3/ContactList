//
//  ContactDetailCellViewModel.swift
//  Contact List

import Foundation

class ContactDetailCellViewModel: ContactCellViewModelProtocol {
    
    // MARK: - Propertie
    var value: String?
    var typeCell: TypeCell?
    var requestTapReturn: (() -> Void)?
    var selectedTextField: (() -> Void)?
    
    // MARK: - init / deinit
    init(value: AnyObject, typeCell: TypeCell) {
        self.typeCell = typeCell
        self.configure(with: value)
    }
    
    // MARK: - Configure cell
    internal func configure(with value: AnyObject) {
        guard let value = value as? String else { return }
        switch self.typeCell {
        case .lastName?:
            self.value = value
        case .name?:
            self.value = value
        default:
            self.value = value
        }
    }
    
    // MARK: - Change data use text
    func changeData(with text: String?) {
        self.value = text
    }
    
    func requestTapReturnAction() {
        requestTapReturn?()
    }
    
    func selectTextField() {
        selectedTextField?()
    }
}
