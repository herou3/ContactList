//
//  ContactDetailCell.swift
//  Contact List

import UIKit
import SnapKit

protocol TaskNameCellDelegate: class {
    func cellDidEndEditingTextField(_ cell: ContactDetailCell, with text: String)
}

class ContactDetailCell: DefaultCell {
    // MARK: - Properties
    var useTypeCell:(() -> Void)?
    private var viewModel: DetailCellViewModel?
    weak var delegate: TaskNameCellDelegate?
    var typeCell: TypeCell?
    var name: String {
        return inputTextField.text ?? ""
    }
    var lastName: String {
        return inputTextField.text ?? ""
    }
    var phone: String {
        return inputTextField.text ?? ""
    }
    var song: String {
        return inputTextField.text ?? ""
    }
    var note: String {
        return inputTextField.text ?? ""
    }
    
    // MARK: - Init table cell
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
        inputTextField.textColor = .gray
        inputTextField.font = UIFont.systemFont(ofSize: 20)
        inputTextField.placeholder = "Enter text"
        inputTextField.tintColor = .black
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.autocapitalizationType = .words
        return inputTextField
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
    
    // MARK: - Configure ContactCell
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
    
    func endEditing(with typeCell: TypeCell) {
        inputTextField.resignFirstResponder()
        switch typeCell {
        case .lastName:
            viewModel?.lastName = lastName
        case .name:
            viewModel?.name = name
        case .phone:
            viewModel?.phone = phone
        case .song:
            viewModel?.song = song
        default:
            viewModel?.note = note
        }
        delegate?.cellDidEndEditingTextField(self, with: name)
    }
    
    override func setupViews() {
        addTypeInputLabel()
        addInputTextField()
        addLineView()
        self.backgroundColor = .silver
    }
    
    func configure(with viewModel: DetailCellViewModel) {
        self.viewModel = viewModel
        setupViews()
        self.typeCell = viewModel.typeCell
        useTypeCell = { [unowned self]  in
            self.endEditing(with: viewModel.typeCell!)
        }
        switch viewModel.typeCell {
        case .lastName?:
            typeInputLabel.text = typeCell?.description
            inputTextField.text = viewModel.lastName
            inputTextField.placeholder = typeCell?.description
        case .name?:
            typeInputLabel.text = typeCell?.description
            inputTextField.text = viewModel.name
            inputTextField.placeholder = typeCell?.description
        case .phone?:
            typeInputLabel.text = typeCell?.description
            inputTextField.keyboardType = .phonePad
            inputTextField.text = viewModel.phone
            inputTextField.placeholder = typeCell?.description
        case .song?:
            typeInputLabel.text = typeCell?.description
            inputTextField.text = viewModel.song
            inputTextField.placeholder = typeCell?.description
        default:
            typeInputLabel.text = typeCell?.description
            inputTextField.text = viewModel.note
            inputTextField.placeholder = typeCell?.description
        }
    }
}

extension ContactDetailCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        useTypeCell?()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        setupClearButton()
        guard let text = textField.text else { return true }
        let newLenght = text.count + string.count - range.length
        return newLenght <= Constant.contactPropertyCharactersCount
    }
}
