//
//  ContactDetailCell.swift
//  Contact List

import UIKit
import SnapKit

class ContactDetailCell: DefaultCell {
    // MARK: - Properties
    private var didChangeText: ((_ text: String?) -> Void)?
    private var didTapReturnButton: (() -> Void)?
    private var viewModel: ContactDetailCellViewModel?
    private var typeCell: TypeCell?
    private var value: String {
        return inputTextField.text ?? ""
    }
    
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
    
    private var inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.textColor = .slategray
        inputTextField.font = UIFont.systemFont(ofSize: 20)
        inputTextField.placeholder = "Enter text"
        inputTextField.tintColor = .black
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.autocapitalizationType = .words
        inputTextField.returnKeyType = .next
        inputTextField.clearButtonWithImage(#imageLiteral(resourceName: "clear-icon"))
        return inputTextField
    }()
    
    lazy private var inputToolbar: UIToolbar = {
        
        var toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector((dismissKeyboard)))
        var flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        var nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(tapNextButton(_:)))
        
        toolbar.setItems([fixedSpaceButton,
                          nextButton,
                          flexibleSpaceButton,
                          doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkslategray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var clearButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // MARK: - Configure contact detail cell
    private func addTypeInputLabel() {
        addSubview(typeInputLabel)
        typeInputLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(Constant.marginLeftAndRightValue)
            make.bottom.equalTo(self).offset(-Constant.marginLeftAndRightValue)
            make.width.equalTo(140)
        }
    }
    
    private func addInputTextField() {
        addSubview(inputTextField)
        inputTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(Constant.marginLeftAndRightValue)
            make.left.equalTo(self.typeInputLabel.snp.right).offset(Constant.marginLeftAndRightValue)
            make.right.equalTo(self).offset(-Constant.marginLeftAndRightValue)
        }
        self.inputTextField.delegate = self
        self.inputTextField.addTarget(self, action: #selector(textFieldDidChangeText(_:)), for: .editingChanged)
    }
    
    private func addLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(inputTextField.snp.bottom).offset(10)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(2)
            make.bottom.equalTo(self)
        }
    }
    
    private func setupClearButton() {
        for view in inputTextField.subviews {
            if let clearButton = view as? UIButton {
                clearButton.setImage(#imageLiteral(resourceName: "clear-icon"), for: .normal)
            }
        }
    }
    
    override func setupViews() {
        addTypeInputLabel()
        addInputTextField()
        addLineView()
        self.backgroundColor = .silver
    }
    
    func configure(with viewModel: ContactDetailCellViewModel) {
        self.viewModel = viewModel
        self.typeCell = viewModel.typeCell
        
        setupViews()
        
        didTapReturnButton = { [weak viewModel] in
            viewModel?.requestTapReturnAction()
        }
        
        viewModel.selectedTextField = { [] in
            self.inputTextField.becomeFirstResponder()
        }
        
        didChangeText = { [weak viewModel] text in
            self.endEditing(with: viewModel?.typeCell)
            viewModel?.changeData(with: text)
        }
        
        typeInputLabel.text = typeCell?.description
        if typeCell == .phone {
            inputTextField.keyboardType = .phonePad
        }
        inputTextField.text = viewModel.value
        inputTextField.placeholder = typeCell?.description
    }
    
    // MARK: - Observe text changing
    func endEditing(with typeCell: TypeCell?) {
        viewModel?.value = value
    }
    
    @objc private func textFieldDidChangeText(_ textField: UITextField) {
        didChangeText?(textField.text)
    }
    
    @objc private func tapNextButton(_ sendor: UIBarButtonItem) {
        didTapReturnButton?()
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
}

// MARK: - Extension textfield delegate
extension ContactDetailCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        didTapReturnButton?()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLenght = text.count + string.count - range.length
        return newLenght <= Constant.contactPropertyCharactersCount
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if typeCell == .phone {
            textField.inputAccessoryView = inputToolbar
        }
        
        return true
    }
}
