//
//  Alert.swift
//  Contact List

import UIKit

struct Alert {
    
    // MARK: - Show default alert
    static func returnImagePicker(on vicewController: UIViewController,
                                  with title: String,
                                  message: String) -> UIImagePickerController {
        
        let imagePickerController = UIImagePickerController()
        
        let actionSheet = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera",
                                            style: .default, handler: { (_) in
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                vicewController.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera is no avilable")
            }
            imagePickerController.sourceType = .camera
            vicewController.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library",
                                            style: .default, handler: { (_) in
                                                imagePickerController.sourceType = .photoLibrary
        vicewController.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        vicewController.present(actionSheet, animated: true, completion: nil)
        return imagePickerController
    }
    
    static func returnDefaultAlert(on viewController: UIViewController,
                                   with title: String,
                                   message: String,
                                   action: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: title, style: .default) { (_) in
            action()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        alert.view.tintColor = UIColor.darkslategray
        viewController.present(alert, animated: true, completion: nil)
    }
}
