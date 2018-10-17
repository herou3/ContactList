//
//  ContactTableCell.swift
//  Contact List
//
//  Created by Pavel Kurilov on 19.08.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit
import SnapKit

class ContactTableCell: DefaultCell {

    // MARK: - Init table cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder!) has not been implemented")
    }

    // MARK: - Create UIElements for cell
    private var contactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Portrait_placeholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private var fullNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "default string"
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.numberOfLines = 2
        return nameLabel
    }()

    private var phoneNumberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.text = "+7 906 199-26-90"
        numberLabel.textColor = .gray
        numberLabel.font = UIFont.systemFont(ofSize: 12)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        return numberLabel
    }()

    // MARK: - Configure ContactCell
    private func addContactImageView() {
        addSubview(contactImageView)
        contactImageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(Constant.marginLeftAndRightValue)
            make.width.equalTo(Constant.cellHeight)
            make.bottom.equalTo(self).offset(-Constant.marginLeftAndRightValue)
        }
    }

    private func addFullNameLabel() {
        addSubview(fullNameLabel)
        fullNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(Constant.marginLeftAndRightValue)
            make.left.equalTo(self.contactImageView.snp.right).offset(Constant.marginLeftAndRightValue)
            make.right.equalTo(self).offset(-Constant.marginLeftAndRightValue)
        }
    }

    private func addPhoneNumberLabel() {
        addSubview(phoneNumberLabel)
        phoneNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.fullNameLabel.snp.bottom).offset(Constant.marginLeftAndRightValue)
            make.left.equalTo(self.fullNameLabel)
            make.right.equalTo(self.fullNameLabel)
            make.bottom.equalTo(self.contactImageView.snp.bottom).offset(-Constant.marginLeftAndRightValue)
        }
    }

    override func setupViews() {
        addContactImageView()
        addFullNameLabel()
        addPhoneNumberLabel()
    }
    
    func updateDataForCell(viewModel: ContactTableCellViewModelProtocol) {
        contactImageView.image = viewModel.image
        fullNameLabel.text = viewModel.fullName
        phoneNumberLabel.text = viewModel.phoneNumber
    }
}
