//
//  ContactSongCell.swift
//  Contact List
//
//  Created by Pavel Kurilov on 20.09.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit
import SnapKit

class  ContactSongCell: DefaultCell {
    // MARK: - Properties
    private var changeSong: ((_ text: String?) -> Void)?
    private var viewModel: ContactSongCellViewModel?

    // MARK: - Init table
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder!) has not been implemented")
    }
    
    // MARK: - Create UIElements for cell
    private var chooseSongButton: UIButton = {
        let songButton = UIButton()
        songButton.backgroundColor = .silver
        songButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        songButton.tintColor = .black
        songButton.translatesAutoresizingMaskIntoConstraints = false
        songButton.contentHorizontalAlignment = .left
        return songButton
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkslategray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Configure song cell
    private func addChooseSongButton() {
        addSubview(chooseSongButton)
        chooseSongButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(Constant.marginLeftAndRightValue / 2)
            make.left.equalTo(self).offset(Constant.marginLeftAndRightValue)
            make.right.equalTo(self).offset(-Constant.marginLeftAndRightValue)
            make.bottom.equalTo(self).offset(-Constant.marginLeftAndRightValue / 2)
        }
        self.chooseSongButton.addTarget(self,
                                        action: #selector(changeTypeSongAction),
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
        addChooseSongButton()
        addLineView()
        self.backgroundColor = .silver
    }
    
    func configure(with viewModel: ContactSongCellViewModel) {
        
        self.viewModel = viewModel
        
        setupViews()
        
        changeSong = { [weak viewModel] text in
            viewModel?.requestAction()
        }
        if viewModel.value != nil {
            chooseSongButton.setTitle(viewModel.value, for: .normal)
        } else {
            chooseSongButton.setTitle("Choice song", for: .normal)
        }
        chooseSongButton.setTitleColor(.slategray, for: .normal)
    }
    
    // MARK: - Observe text changing
    @objc private func changeTypeSongAction(_ sender: UIButton) {
        changeSong?("Fass")
    }
}
