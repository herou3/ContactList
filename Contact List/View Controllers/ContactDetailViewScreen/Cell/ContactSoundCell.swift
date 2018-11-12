//
//  ContactSoundCell.swift
//  Contact List
//
//  Created by Pavel Kurilov on 20.09.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit
import SnapKit

class  ContactSoundCell: DefaultCell {
    // MARK: - Properties
    var changeSoundBlock: (() -> Void)?

    // MARK: - Init table
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder!) has not been implemented")
    }
    
    // MARK: - Create UIElements for cell
    private var chooseSoundButton: UIButton = {
        let soundButton = UIButton()
        soundButton.backgroundColor = .silver
        soundButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        soundButton.tintColor = .black
        soundButton.translatesAutoresizingMaskIntoConstraints = false
        soundButton.contentHorizontalAlignment = .left
        return soundButton
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkslategray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Configure sound cell
    private func addChooseSoundButton() {
        addSubview(chooseSoundButton)
        chooseSoundButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(Constant.marginLeftAndRightValue / 2)
            make.left.equalTo(self).offset(Constant.marginLeftAndRightValue)
            make.right.equalTo(self).offset(-Constant.marginLeftAndRightValue)
            make.bottom.equalTo(self).offset(-Constant.marginLeftAndRightValue / 2)
        }
        self.chooseSoundButton.addTarget(self,
                                        action: #selector(onDidChangeSound),
                                        for: .touchUpInside)
    }
    
    private func addLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.bottom).offset(-2)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(2)
            make.bottom.equalTo(self)
        }
    }
    
    override func setupViews() {
        addChooseSoundButton()
        addLineView()
        self.backgroundColor = .silver
    }
    
    func configure(with viewModel: ContactSoundCellViewModel) {
        
        if viewModel.value != nil {
            chooseSoundButton.setTitle(viewModel.value, for: .normal)
        } else {
            chooseSoundButton.setTitle("Choice sound", for: .normal)
        }
        chooseSoundButton.setTitleColor(.slategray, for: .normal)
    }
    
    // MARK: - Bind to viewModel
    @objc private func onDidChangeSound(_ sender: UIButton) {
        changeSoundBlock?()
    }
}
