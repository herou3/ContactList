//
//  ContactDetailViewModelProtocol.swift
//  Contact List

import UIKit

protocol ContactDetailViewModelProtocol {
    
    var firstName: String? { get set }
    var lastName: String? { get set }
    var phone: String? { get set }
    var song: String? { get set }
    var note: String? { get set }
    var image: UIImage? { get set }
    
    func numberOfRows() -> Int
    func detailCellViewModel(forIndexPath indexPath: IndexPath) -> ContactCellViewModelProtocol?
    func saveContact()
}
