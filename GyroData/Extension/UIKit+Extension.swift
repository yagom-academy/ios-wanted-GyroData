//
//  UIKit+Extension.swift
//  GyroData
//
//  Created by sole on 2022/09/27.
//

import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func presentAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}

extension NSLayoutConstraint {
    func withPriority(_ p: UILayoutPriority) -> Self {
        self.priority = p
        return self
    }
}
