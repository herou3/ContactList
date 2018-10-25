//
//  ContactsListController.swift
//  Contact List
//
//  Created by Pavel Kurilov on 18.08.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit
import SnapKit

class ContactsListController: UIViewController {

    // MARK: - Properties
    private var viewModel: ContactsListViewModelProtocol?
    private let contactCellReuseIdentifier = "cellId"
    private let tableView = UITableView()
    private var searchBar = UISearchBar()
    private var isSearhBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - Init ContactsListController
    init(viewModel: ContactsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .darkslategray
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBarNew()
        configureTablleView()
        configureNavigationBar()
        addKeyboardEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.bounds.width, height: 64)
    }
    
    // MARK: - Configure contact list
    private func configureTablleView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset((self.navigationController?.navigationBar.bounds.height ?? 64) + 64)
            make.left.equalTo(self.view.snp.left)
            make.bottom.equalTo(self.view.snp.bottom)
            make.right.equalTo(self.view.snp.right)
        }
        tableView.backgroundColor = UIColor.white
        tableView.register(ContactTableCell.self,
                           forCellReuseIdentifier: contactCellReuseIdentifier)
        tableView.showsHorizontalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func configureSearchBarNew() {
        self.view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(self.navigationController?.navigationBar.bounds.height ?? 64)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(64)
        }
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.white
        searchBar.tintColor = UIColor.appPrimary
        searchBar.backgroundColor = .appPrimary
    }
    
    private func configureNavigationBar() {
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.barTintColor = .silver
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addNewContactAction(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.title = "Contact List"
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
    
    // MARK: - Internal actions
    @objc func addNewContactAction(_ sender: UIBarButtonItem) {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.showNewContactViewController()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
    }
    
    @objc private func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if #available(iOS 11.0, *) {
            self.tableView.contentInset = .zero
        } else {
            self.tableView.contentInset = UIEdgeInsets(top: Constant.insertFromSize, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableView DataSource
extension ContactsListController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(numberOfRowsInSection: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: contactCellReuseIdentifier,
                                                       for: indexPath)
            as? ContactTableCell else { return UITableViewCell(style: .default,
                                                         reuseIdentifier: contactCellReuseIdentifier) }
        guard let cellViewModel = viewModel?.cellViewModel(forIndexPath: indexPath) else { return cell }
        cell.updateDataForCell(viewModel: cellViewModel)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return Constant.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.selectRow(atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.titleForHeader(InSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel?.getIndexTitles()
    }
}

// MARK: - extension UISearchBarDelegate
extension ContactsListController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        viewModel?.cancelSearchingProcess()
        self.tableView.reloadData()
        searchBar.showsCancelButton = false
        searchBar.text = ""
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if !self.isSearhBarEmpty {
            guard let searchText = searchBar.text else { return }
            viewModel?.filterContentForSearchText(searchText)
            tableView.reloadData()
        } else {
            viewModel?.cancelSearchingProcess()
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !self.isSearhBarEmpty {
            guard let searchText = searchBar.text else { return }
            viewModel?.filterContentForSearchText(searchText)
            tableView.reloadData()
        } else {
            viewModel?.cancelSearchingProcess()
            tableView.reloadData()
        }
    }
}
