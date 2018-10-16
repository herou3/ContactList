//
//  UITextField+ ClearButton.swift
//  Contact List
//
//  Created by Pavel Kurilov on 30.08.2018.
//  Copyright © 2018 Pavel Kurilov. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func clearButtonWithImage(_ image: UIImage) {
        let clearButton = UIButton()
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(self.clear(sender:)), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }
    
    @objc func clear(sender: AnyObject) {
        self.text = ""
    }
}
