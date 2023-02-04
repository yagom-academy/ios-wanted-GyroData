//
//  AlertBuilder.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

protocol AlertBuilder {
    var alertController: UIAlertController { get }
    func setTitle(to title: String) -> AlertBuilder
    func setMessage(to message: String) -> AlertBuilder
    func setButton(
        title: String?,
        style: UIAlertAction.Style,
        completion: ((UIAlertAction) -> Void)?
    ) -> AlertBuilder
    
    func build() -> UIAlertController
}

class AlertConcreteBuilder: AlertBuilder {
    var alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    func setTitle(to title: String) -> AlertBuilder {
        alertController.title = title
        return self
    }
    
    func setMessage(to message: String) -> AlertBuilder {
        alertController.message = message
        return self
    }
    
    func setButton(title: String?, style: UIAlertAction.Style, completion: ((UIAlertAction) -> Void)?) -> AlertBuilder {
        let action = UIAlertAction(title: title, style: style, handler: completion)
        alertController.addAction(action)
        return self
    }
    
    func build() -> UIAlertController {
        return alertController
    }
}
