//
//  ContactsTableViewModelProtocol.swift
//  Contact List

import Foundation

protocol ContactsListViewModelProtocol {
    
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> ContactTableCellViewModelProtocol?
    
    func viewModelForSelectedRow() -> ContactDetailViewModelProtocol?
    func selectRow(atIndexPath indexPath: IndexPath)
}
