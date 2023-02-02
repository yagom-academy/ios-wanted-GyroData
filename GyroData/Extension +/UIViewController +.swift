//
//  UIViewController +.swift
//  GyroData
//
//  Created by 로빈 on 2023/02/02.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)

        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
}
