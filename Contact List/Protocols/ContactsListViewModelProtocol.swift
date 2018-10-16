//
//  ContactsTableViewModelProtocol.swift
//  Contact List

import Foundation

protocol ContactsListViewModelProtocol {
    
    func numberOfRows(numberOfRowsInSection section: Int) -> Int
    func numberOfSections() -> Int
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> ContactTableCellViewModelProtocol?

    func selectRow(atIndexPath indexPath: IndexPath)
    func titleForHeader(InSection section: Int) -> String
    func getIndexTitles() -> [String]
    
    func filterContentForSearchText(_ searchText: String)
    func cancelSearchingProcess()
    
    func showNewContactViewController()
}
