//
//  ContactDetailViewController.swift
//  Contact List

import SnapKit

class ContactDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let contactDetailView = ContactImageView()
    private var contactDetailViewModel: ContactDetailViewModel?
    private let detailCellReuse = "cellIdDetail"
    private let dataTableView: UITableView = UITableView()
    
    init(viewModel: ContactDetailViewModel) {
        self.contactDetailViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        contactDetailView.update(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContactDetailController()
        configureNavigationBar()
        self.view.backgroundColor = .darkslategray
    }
    
    // MARK: - Configure ContactDetailViewController
    private func addContactDetailView() {
        self.view.addSubview(contactDetailView)
        contactDetailView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.equalTo(self.view.snp.centerX).offset(-Constant.contactImageSize / 4)
            make.right.equalTo(self.view.snp.centerX).offset(Constant.contactImageSize / 4)
            make.height.equalTo(Constant.contactImageSize / 2 + 3 * Constant.marginLeftAndRightValue)
        }
        contactDetailView.addGestureRecognizer(configureGesture())
    }
    
    private func addDataTableView() {
        self.view.addSubview(dataTableView)
        dataTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contactDetailView.snp.bottom).offset(Constant.marginLeftAndRightValue)
            make.left.equalTo(self.view.snp.left)
            make.bottom.equalTo(self.view.snp.bottom)
            make.right.equalTo(self.view.snp.right)
        }
        dataTableView.dataSource = self
        dataTableView.backgroundColor = .darkslategray
        dataTableView.tableFooterView = UIView()
        dataTableView.separatorStyle = .none
        dataTableView.isScrollEnabled = false
        dataTableView.register(ContactDetailCell.self, forCellReuseIdentifier: detailCellReuse)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .silver
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .black
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = contactDetailViewModel?.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: nil)
    }
    
    private func configureContactDetailController() {
        addContactDetailView()
        addDataTableView()
    }
    
    // MARK: - Connfigure gesture
    private func configureGesture() -> UITapGestureRecognizer {
        let configGesture = UITapGestureRecognizer(target: self,
                                                   action: #selector(choosePhoto(sender:)))
        configGesture.numberOfTapsRequired = 1
        configGesture.numberOfTouchesRequired = 1
        return configGesture
    }
    
    // MARK: - Internal functions
    @objc private func choosePhoto(sender: UITapGestureRecognizer) {
        
        let alertController = UIAlertController(title: NSLocalizedString("Источник фотографии",
                                                                         comment: "Источник фотографии"),
                                                message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("Камера", comment: "Камера"),
                                         style: .default,
                                         handler: { (_) in
            self.chooseImagePickerAction(source: .camera)
        })
        let photoLibAction = UIAlertAction(title: NSLocalizedString("Фото", comment: "Фото"),
                                           style: .default,
                                           handler: { (_) in
            self.chooseImagePickerAction(source: .photoLibrary)
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Отмена", comment: "Отмена"), style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func chooseImagePickerAction(source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ContactDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        contactDetailView.updateImage(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ContactDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactDetailViewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return Constant.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: detailCellReuse,
                                                       for: indexPath)
            as? ContactDetailCell else { return UITableViewCell(style: .default,
                                                               reuseIdentifier: detailCellReuse) }
        let detailCellVM = contactDetailViewModel?.detailCellViewModel(forIndexPath: indexPath) ??
            DetailCellViewModel(viewModel: contactDetailViewModel!, typeCell: .name)
        cell.selectionStyle = .none
        cell.configure(with: detailCellVM)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: true)
        return indexPath
    }
}
