//
//  ContactDetailController.swift
//  Contact List

import SnapKit

class ContactDetailController: UIViewController {
    
    // MARK: - Properties
    private var contactDetailView = ContactImageView()
    private var contactDetailViewModel: ContactDetailViewModel?
    private let detailCellReuse = "cellIdDetail"
    private let cellNoteId = "cellNoteId"
    private let cellSoundId = "cellSoundId"
    private let cellDeleteId = "cellDeleteId"
    private let dataTableView: UITableView = UITableView()
    
    // MARK: - Init / deinit
    init(viewModel: ContactDetailViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.bindTo(viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContactDetailController()
        self.view.backgroundColor = .darkslategray
        self.tapOnTheReturnButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.contactDetailViewModel?.onDidUpdateSound(soundName: contactDetailViewModel?.sound)
        self.dataTableView.reloadData()
    }
    
    // MARK: - Configure contact detail controller
    private func configureContactDetailView() {
        contactDetailView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 206)
    }
    
    private func addDataTableView() {
        self.view.addSubview(dataTableView)
        dataTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(Constant.marginLeftAndRightValue)
            make.left.equalTo(self.view.snp.left)
            make.bottom.equalTo(self.view.snp.bottom)
            make.right.equalTo(self.view.snp.right)
        }
        dataTableView.dataSource = self
        dataTableView.estimatedRowHeight = 50
        dataTableView.backgroundColor = .darkslategray
        dataTableView.tableFooterView = UIView()
        dataTableView.separatorStyle = .none
        dataTableView.register(ContactDetailCell.self, forCellReuseIdentifier: detailCellReuse)
        dataTableView.register(ContactNoteCell.self, forCellReuseIdentifier: cellNoteId)
        dataTableView.register(ContactSoundCell.self, forCellReuseIdentifier: cellSoundId)
        dataTableView.register(ContactDeleteCell.self, forCellReuseIdentifier: cellDeleteId)
        dataTableView.tableHeaderView = contactDetailView
        contactDetailView.addGestureRecognizer(configureGesture())
    }
    
    private func addKeyboardEvents() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: Notification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    private func configureContactDetailController() {
        configureContactDetailView()
        addDataTableView()
        addKeyboardEvents()
        hideKeyboardOutsideTap()
    }
    
    // MARK: - Connfigure gesture
    private func configureGesture() -> UITapGestureRecognizer {
        let configGesture = UITapGestureRecognizer(target: self,
                                                   action: #selector(choosePhoto(sender:)))
        configGesture.numberOfTapsRequired = 1
        configGesture.numberOfTouchesRequired = 1
        return configGesture
    }
    
    private func hideKeyboardOutsideTap() {
        let hideKeyboardGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                                 action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGesture)
    }
    
    // MARK: - Methods change photo
    @objc private func choosePhoto(sender: UITapGestureRecognizer) {
        
        let alertController = UIAlertController(title: NSLocalizedString("Datasource photo",
                                                                         comment: "Datasource photo"),
                                                message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera",
                                                                  comment: "Camera"),
                                         style: .default,
                                         handler: { (_) in
            self.chooseImagePickerAction(source: .camera)
        })
        
        let photoLibAction = UIAlertAction(title: NSLocalizedString("Photo Library",
                                                                    comment: "Photo Library"),
                                           style: .default,
                                           handler: { (_) in
            self.chooseImagePickerAction(source: .photoLibrary)
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"),
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibAction)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = UIColor.darkslategray
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    private func chooseImagePickerAction(source: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        self.present(imagePicker, animated: true) {
            self.view.endEditing(true)
        }
    }
    
    // MARK: - Bind to viewModel
    private func bindTo(_ viewModel: ContactDetailViewModel) {
        self.contactDetailViewModel = viewModel
        contactDetailView.updateImage(image: viewModel.image)
        contactDetailViewModel?.deleteContactBlock = { [unowned self] in
            Alert.defaultAlert(on: self,
                                     with: "Delete",
                                     message: "Do you want to delete this contact?", action: {
                                        self.contactDetailViewModel?.onDidGetRequestDelete()
            })
        }
    }
    // MARK: - Return barButtonItem
    func barButtonItem(typeButton: TypeItemButton) -> UIBarButtonItem {
        switch typeButton {
        case .back:
            return UIBarButtonItem(title: "<",
                                   style: .plain,
                                   target: nil,
                                   action: nil)
        default:
            return UIBarButtonItem(title: "Save",
                                   style: .done,
                                   target: self,
                                   action: #selector(saveObject))
        }
    }
    
    // MARK: - Methods tap on the return
    private func tapOnTheReturnButtonAction() {
        contactDetailViewModel?.didRequestTapBlock = { [] value in
            let indexPathNextCell = IndexPath(row: value,
                                              section: 0)
            guard let detailCell = self.dataTableView.cellForRow(at: indexPathNextCell) as? ContactDetailCell else {
                guard let noteCell = self.dataTableView.cellForRow(at: indexPathNextCell) as? ContactNoteCell else {
                    return
                }
                noteCell.inputTextView.becomeFirstResponder()
                return
            }
            detailCell.inputTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - Internal methods
    @objc private func saveObject() {
        contactDetailViewModel?.saveContact()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        dataTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
    }
    
    @objc private func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        dataTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if #available(iOS 11.0, *) {
            dataTableView.contentInset = .zero
        } else {
            dataTableView.contentInset = UIEdgeInsets(top: Constant.insertFromSize, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Extension image picker controller
extension ContactDetailController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: Any]) {
        guard var image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        image = image.resizeWithWidth(width: 700) ?? image
        let resizeImage = UIImageJPEGRepresentation(image, 0)
        contactDetailView.updateImage(image: UIImage(data: resizeImage ?? Data()))
        contactDetailViewModel?.updateImageBlock?(UIImage(data: resizeImage ?? Data()))
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension table data source
extension ContactDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactDetailViewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detailCellVM = contactDetailViewModel?.detailCellViewModel(forIndexPath: indexPath) ??
            ContactDetailCellViewModel(value: contactDetailViewModel?.note, typeCell: .name)
        
        guard let cellSound = tableView.dequeueReusableCell(withIdentifier: cellSoundId, for: indexPath)
            as? ContactSoundCell else { return UITableViewCell(style: .default, reuseIdentifier: cellSoundId) }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: detailCellReuse, for: indexPath)
            as? ContactDetailCell else { return UITableViewCell(style: .default, reuseIdentifier: detailCellReuse) }
        guard let cellNote = tableView.dequeueReusableCell(withIdentifier: cellNoteId, for: indexPath)
            as? ContactNoteCell else { return UITableViewCell(style: .default, reuseIdentifier: cellNoteId)}
        guard let cellDelete = tableView.dequeueReusableCell(withIdentifier: cellDeleteId, for: indexPath)
            as? ContactDeleteCell else { return UITableViewCell(style: .default, reuseIdentifier: cellDeleteId)}
        
        if let detailCellViewModel = detailCellVM as? ContactDetailCellViewModel {
            cell.configure(with: detailCellViewModel)
            cell.changeTextBlock = { [] text in
                detailCellViewModel.changeData(with: text)
            }
            return cell
        } else if let songCellViewModel = detailCellVM as? ContactSoundCellViewModel {
            cellSound.configure(with: songCellViewModel)
            cellSound.changeSoundBlock = { [] in
                songCellViewModel.requestAction()
            }
            return cellSound
        } else if let noteCellViewModel = detailCellVM as? ContactNoteCellViewModel {
            cellNote.configure(with: noteCellViewModel)
            cellNote.changeTextBlock = { [] text in
                noteCellViewModel.changeData(with: text)
            }
            return cellNote
        } else {
            let deleteCellViewModel = detailCellVM as? ContactDeleteCellViewModel
            cellDelete.configure(with: deleteCellViewModel)
            cellDelete.deleteRequestBlock = { [] in
                deleteCellViewModel?.deleteAction()
            }
            return cellDelete
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
