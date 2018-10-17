//
//  SongPickerController.swift
//  Contact List
//
//  Created by Pavel Kurilov on 04.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit

class SongPickerController: UIViewController {
    
    // MARK: - Properties
    private let songPickerViewModel: SongPickerViewModel?
    private let songPickerView = UIPickerView()
    private var choisedSong: String?
    
    // MARK: - Init / deinit
    init(viewModel: SongPickerViewModel) {
        self.songPickerViewModel = viewModel
        choisedSong = self.songPickerViewModel?.songValue(forRow: 0)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureSongPickerController()
    }
    
    // MARK: - Configure song picker controller
    private func addSongPickerController() {
        self.view.addSubview(songPickerView)
        songPickerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        self.songPickerView.delegate = self
        self.songPickerView.dataSource = self
        self.songPickerView.backgroundColor = .silver
        self.songPickerView.tintColor = UIColor.appPrimary
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .silver
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .black
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(closeViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(saveChoisedSong))
    }
    
    private func configureSongPickerController() {
        addSongPickerController()
        configureNavigationBar()
    }
    
    // MARK: - Internal methods
    @objc private func saveChoisedSong() {
        songPickerViewModel?.saveSongValue(self.choisedSong ?? "test")
    }
    
    @objc private func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension UIPickerViewDelegate and UIPickerViewDataSource
extension SongPickerController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.songPickerViewModel?.numberOfRows() ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.choisedSong = self.songPickerViewModel?.songValue(forRow: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.songPickerViewModel?.songValue(forRow: row)
    }
}
