//
//  UIViewController+Utils.swift
//  GyroData
//
//  Created by sole on 2022/09/27.
//

import UIKit

extension UIViewController {
    func presentAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}
