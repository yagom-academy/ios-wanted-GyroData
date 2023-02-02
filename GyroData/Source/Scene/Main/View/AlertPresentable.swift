//
//  AlertPresentable.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/01/31.
//

import UIKit

protocol AlertPresentable: UIViewController {
    func createAlert(title: String?, message: String?) -> UIAlertController
    func createAlertAction(title: String?, completion: @escaping () -> Void) -> UIAlertAction
}

extension AlertPresentable {
    func createAlert(title: String?, message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    func createAlertAction(title: String?, completion: @escaping () -> Void) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) { _ in
            completion()
        }
    }
}
