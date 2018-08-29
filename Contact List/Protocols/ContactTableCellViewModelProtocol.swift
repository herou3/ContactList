//
//  ContactTableCellViewModelProtocol.swift
//  Contact List

import UIKit

protocol ContactTableCellViewModelProtocol: class {
   
    var fullName: String { get }
    var phoneNumber: String { get }
    var image: UIImage { get }
    var value: String? { get set }
}
