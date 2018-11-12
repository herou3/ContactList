//
//  ContactDetailCellViewModel.swift
//  Contact List

import Foundation

class ContactDetailCellViewModel: ContactCellViewModelProtocol {
    
    // MARK: - Propertie
    var value: String?
    var cellType: StandartCellType?
    var onDidTapReturnButton: (() -> Void)?
    
    // MARK: - init / deinit
    init(value: String?, cellType: StandartCellType) {
        self.cellType = cellType
        self.configure(with: value)
    }
    
    // MARK: - Configure self
    func configure(with text: String?) {
        self.value = text
    }
    
    // MARK: - bind to Detail view model
    func requestSelectNextResponder() {
        onDidTapReturnButton?()
    }
}
