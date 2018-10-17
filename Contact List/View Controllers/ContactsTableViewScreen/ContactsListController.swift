//
//  ContactsListController.swift
//  Contact List
//
//  Created by Pavel Kurilov on 18.08.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit
import SnapKit

class ContactsListController: UITableViewController {

    // MARK: - Properties
    private var viewModel: ContactsListViewModelProtocol?
    private let recipeCellReuseIdentifier = "cellId"
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Init ContactsListController
    init(viewModel: ContactsListViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
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
        configurateTablleView()
        configureNavigationBar()
        configurateSearchBar()
        addKeyboardEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Configure contact list
    private func configurateTablleView() {
        tableView?.backgroundColor = UIColor.white
        tableView?.register(ContactTableCell.self,
                            forCellReuseIdentifier: recipeCellReuseIdentifier)
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = UIView()
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
    
    private func configurateSearchBar() {
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.appPrimary
        searchController.searchBar.backgroundColor = .appPrimary
        
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func addKeyboardEvents() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
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
    
    private func searhBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    @objc private func keyboardWillChange(notification: Notification) {
        print("keyboard will show: \(notification.name.rawValue)")
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
        } else {
            if #available(iOS 11.0, *) {
                tableView.contentInset = .zero
            } else {
                tableView.contentInset = UIEdgeInsets(top: Constant.insertFromSize, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableView DataSource
extension ContactsListController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(numberOfRowsInSection: section) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: recipeCellReuseIdentifier,
                                                       for: indexPath)
            as? ContactTableCell else { return UITableViewCell(style: .default,
                                                         reuseIdentifier: recipeCellReuseIdentifier) }
        guard let cellViewModel = viewModel?.cellViewModel(forIndexPath: indexPath) else { return cell }
        cell.updateDataForCell(viewModel: cellViewModel)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return Constant.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.selectRow(atIndexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.titleForHeader(InSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel?.getIndexTitles()
    }
}

// MARK: - extension UISearchResultsUpdating
extension ContactsListController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if !searhBarIsEmpty() {
            guard let searchText = searchController.searchBar.text else { return }
            viewModel?.filterContentForSearchText(searchText)
            tableView.reloadData()
        } else {
            viewModel?.cancelSearchingProcess()
            tableView.reloadData()
        }
    }
}

// MARK: - extension UISearchBarDelegate
extension ContactsListController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        viewModel?.cancelSearchingProcess()
        self.tableView.reloadData()
    }
}
