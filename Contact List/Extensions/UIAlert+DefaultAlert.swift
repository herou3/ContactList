//
//  UIAlert+defaultAlert
//  Contact List

import UIKit

extension UIViewController {
    
    // MARK: - Show default alert
    func defaultAlert(with title: String,
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
        self.present(alert, animated: true, completion: nil)
    }
}
