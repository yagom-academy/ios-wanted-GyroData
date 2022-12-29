//
//  UIViewController+extension.swift
//  GyroData
//
//  Created by 우롱차 on 2022/12/29.
//

import UIKit

extension UIViewController {
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive))
        self.present(alert, animated: true)
    }
}
