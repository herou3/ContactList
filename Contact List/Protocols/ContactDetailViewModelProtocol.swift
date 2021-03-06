//
//  ContactDetailViewModelProtocol.swift
//  Contact List

import UIKit

protocol ContactDetailViewModelProtocol {
    
    var firstName: String? { get set }
    var lastName: String? { get set }
    var phone: String? { get set }
    var sound: String? { get set }
    var note: String? { get set }
    var image: UIImage? { get set }
    
    var numberOfRows: Int { get }
    
    func detailCellViewModel(forIndexPath indexPath: IndexPath) -> ContactCellViewModelProtocol?
    func saveContact()
    func contactName() -> String
}
