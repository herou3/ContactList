//
//  UIAlert+defaultAlert
//  Contact List

import UIKit

struct Alert {
    
    // MARK: - Show default alert
    static func defaultAlert(on viewController: UIViewController,
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
