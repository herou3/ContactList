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
    
    // MARK: - Init ContactsListController
    init(viewModel: ContactsListViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateTablleView()
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
}

// MARK: - UITableView DataSource
extension ContactsListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: recipeCellReuseIdentifier,
                                                       for: indexPath)
            as? ContactTableCell else { return UITableViewCell(style: .default,
                                                         reuseIdentifier: recipeCellReuseIdentifier) }
        guard let cellViewModel = viewModel?.cellViewModel(forIndexPath: indexPath) else { return cell }
        cell.updateDataForCell(viewModel: cellViewModel)
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
        guard let detailViewModel = viewModel.viewModelForSelectedRow() as? ContactDetailViewModel else { return }
        self.navigationController?.pushViewController(ContactDetailViewController(viewModel: detailViewModel), animated: true)
    }
}
