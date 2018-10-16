//
//  ContactDetallCoordinator.swift
//  Contact List
//
//  Created by Pavel Kurilov on 05.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit

final class ContactDetallCoordinator {

    // MARK: - Properties
    private weak var navigationController: UINavigationController?
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
     // MARK: - Private implementation
    private func showSongPickerController(viewModel: SongPickerViewModel) {
        let chc = SongPickerController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: chc)
        navigationController?.present(navController, animated: true, completion: nil)
    }
}
