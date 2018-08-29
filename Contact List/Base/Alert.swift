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
}
