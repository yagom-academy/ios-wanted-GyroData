//
//  UIAlertController +.swift
//  GyroData
//
//  Created by 로빈 on 2023/02/02.
//

import UIKit

extension UIAlertController {
    static func show(title: String, message: String, target: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)

        alert.addAction(OKAction)
        target.present(alert, animated: true, completion: nil)
    }
}
