//
//  ContactDeleteCell.swift
//  Contact List
//
//  Created by Pavel Kurilov on 10.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit
import SnapKit

class ContactDeleteCell: DefaultCell {
    
    // MARK: - Properties
    private var contactDeleteCellViewModel: ContactDeleteCellViewModel?
    private var deleteTap: (() -> Void)?
    
    // MARK: - Init / Deintit
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Create UIElements for cell
    private var deleteButton: UIButton = {
        let songButton = UIButton()
        songButton.backgroundColor = .silver
        songButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        songButton.tintColor = .black
        songButton.translatesAutoresizingMaskIntoConstraints = false
        songButton.contentHorizontalAlignment = .center
        songButton.setTitle("Delete Contact", for: .normal)
        songButton.setTitleColor(.black, for: .normal)
        return songButton
    }()
    
    // MARK: - Configure delete cell
    private func addDeleteButton() {
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(Constant.marginLeftAndRightValue * 2)
            make.left.equalTo(self).offset(Constant.marginLeftAndRightValue * 4)
            make.right.equalTo(self).offset(-Constant.marginLeftAndRightValue * 4)
            make.bottom.equalTo(self).offset(-Constant.marginLeftAndRightValue * 2)
            make.height.equalTo(Constant.marginLeftAndRightValue * 4)
        }
        self.deleteButton.addTarget(self,
                                        action: #selector(deleteAction),
                                        for: .touchUpInside)
        self.backgroundColor = UIColor.darkslategray
    }
    
    override func setupViews() {
        addDeleteButton()
    }
    
    func configure(with viewModel: ContactDeleteCellViewModel?) {
        self.contactDeleteCellViewModel = viewModel
        setupViews()
        deleteTap = { [weak viewModel] in
            viewModel?.deleteAction()
        }
    }
    
    // MARK: - Observe text changing
    @objc private func deleteAction(_ sender: UIButton) {
        deleteTap?()
    }
}
