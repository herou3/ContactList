//
//  ContactNoteCell.swift
//  Contact List
//
//  Created by Pavel Kurilov on 20.09.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit
import SnapKit

class ContactNoteCell: DefaultCell {
    // MARK: - Properties
    private var changeText: ((_ text: String?) -> Void)?
    private var viewModel: ContactNoteCellViewModel?
    
    // MARK: - Init table
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder!) has not been implemented")
    }
    
    // MARK: - Create UIElements for cell
    private var typeInputLabel: UILabel = {
        let inputLabel = UILabel()
        inputLabel.textColor = .black
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        inputLabel.font = UIFont.systemFont(ofSize: 20)
        inputLabel.numberOfLines = 1
        return inputLabel
    }()
    
    private var inputTextView: UITextView = {
        let inputTextView = UITextView()
        inputTextView.textColor = .slategray
        inputTextView.font = UIFont.systemFont(ofSize: 20)
        inputTextView.tintColor = .black
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        inputTextView.autocapitalizationType = .sentences
        return inputTextView
    }()
    
    // MARK: - Configure note cell
    private func addTypeInputLabel() {
        addSubview(typeInputLabel)
        typeInputLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(Constant.marginLeftAndRightValue)
            make.width.equalTo(140)
        }
    }
    
    private func addInputTextView() {
        addSubview(inputTextView)
        inputTextView.snp.makeConstraints { (make) in
            make.top.equalTo(typeInputLabel.snp.bottom).offset(Constant.marginLeftAndRightValue)
            make.left.equalTo(self).offset(Constant.marginLeftAndRightValue)
            make.right.equalTo(self).offset(-Constant.marginLeftAndRightValue)
            make.height.equalTo(100)
            make.bottom.equalTo(self).offset(-Constant.marginLeftAndRightValue)
        }
        self.inputTextView.delegate = self
        self.inputTextView.target(forAction: #selector(onDidUpdateText(_:)), withSender: self)
    }
    
    override func setupViews() {
        addTypeInputLabel()
        addInputTextView()
        self.backgroundColor = .silver
    }
    
    func configure(with viewModel: ContactNoteCellViewModel) {
        self.viewModel = viewModel
        setupViews()
        
        changeText = { [weak viewModel] text in
            viewModel?.changeData(with: text)
        }
        viewModel.selectedTextView = { [] in
            self.inputTextView.becomeFirstResponder()
        }
        typeInputLabel.text = "Note"
        inputTextView.text = viewModel.value
    }
    
    // MARK: - Bind to viewModel
    @objc private func onDidUpdateText(_ textView: UITextView) {
        changeText?(textView.text)
    }
}

// MARK: - Extension textfield delegate
extension ContactNoteCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < Constant.notePropertyCharcetersCount
    }
    
    func textViewDidChange(_ textView: UITextView) {
        changeText?(textView.text)
    }
}
