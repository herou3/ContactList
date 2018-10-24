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
    var deleteTap: (() -> Void)?
    
    // MARK: - Init / Deintit
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Create UIElements for cell
    private var deleteButton: UIButton = {
        let soundButton = UIButton()
        soundButton.backgroundColor = .silver
        soundButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        soundButton.tintColor = .black
        soundButton.translatesAutoresizingMaskIntoConstraints = false
        soundButton.contentHorizontalAlignment = .center
        soundButton.setTitle("Delete Contact", for: .normal)
        soundButton.setTitleColor(.black, for: .normal)
        return soundButton
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
                                    action: #selector(onDidDeleteAction),
                                    for: .touchUpInside)
        self.backgroundColor = UIColor.darkslategray
    }
    
    override func setupViews() {
        addDeleteButton()
    }
    
    func configure(with viewModel: ContactDeleteCellViewModel?) {
        setupViews()
    }
    
    // MARK: - Bind to viewModel
    @objc private func onDidDeleteAction(_ sender: UIButton) {
        deleteTap?()
    }
}
