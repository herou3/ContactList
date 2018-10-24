//
//  SoundPickerController.swift
//  Contact List
//
//  Created by Pavel Kurilov on 04.10.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import UIKit

enum TypeItemButton {
    case done
    case close
    case back
}

class SoundPickerController: UIViewController {
    
    // MARK: - Properties
    private let soundPickerViewModel: SoundPickerViewModel?
    private let soundPickerView = UIPickerView()
    private var choisenSound: String?
    
    // MARK: - Init / deinit
    init(viewModel: SoundPickerViewModel) {
        self.soundPickerViewModel = viewModel
        choisenSound = self.soundPickerViewModel?.soundValue(forRow: 0)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSoundPickerController()
    }
    
    // MARK: - Configure sound picker controller
    private func addSoundPickerView() {
        self.view.addSubview(soundPickerView)
        soundPickerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        self.soundPickerView.delegate = self
        self.soundPickerView.dataSource = self
        self.soundPickerView.backgroundColor = .silver
        self.soundPickerView.tintColor = UIColor.appPrimary
    }
    
    private func configureSoundPickerController() {
        addSoundPickerView()
    }
    
    // MARK: - Internal methods
    @objc private func saveChoisenSound() {
        soundPickerViewModel?.saveSoundValue(self.choisenSound ?? "test")
    }
    
    @objc private func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Return navigationItems
    func barButtonItem(type: TypeItemButton) -> UIBarButtonItem {
        switch type {
        case .done:
            return UIBarButtonItem(title: "Done",
                                   style: .done,
                                   target: self,
                                   action: #selector(saveChoisenSound))
        default:
            return UIBarButtonItem(title: "Close",
                                  style: .done,
                                  target: self,
                                  action: #selector(closeViewController))
        }
    }
}

// MARK: - Extension UIPickerViewDelegate and UIPickerViewDataSource
extension SoundPickerController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.soundPickerViewModel?.numberOfRows ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.choisenSound = self.soundPickerViewModel?.soundValue(forRow: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.soundPickerViewModel?.soundValue(forRow: row)
    }
}
