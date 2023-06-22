//
//  AlertBuilder.swift
//  GyroData
//
//  Created by 리지 on 2023/06/16.
//

import UIKit

final class AlertBuilder {
    private let viewController: UIViewController
    private var alertProperties = AlertProperties()
    private var alertActionSuccessProperties = AlertActionProperties()
    private var alertActionCancelProperties = AlertActionProperties()
    private var onSuccess: ((UIAlertAction) -> Void)?
    private var onCancel: ((UIAlertAction) -> Void)?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func withTitle(_ title: String) -> AlertBuilder {
        alertProperties.title = title
        return self
    }
    
    func andMessage(_ message: String) -> AlertBuilder {
        alertProperties.message = message
        return self
    }
    
    func preferredStyle(_ style: UIAlertController.Style) -> AlertBuilder {
        alertProperties.preferredStyle = style
        return self
    }
    
    func onSuccessAction(title: String, _ onSuccess: @escaping ((UIAlertAction) -> Void)) -> AlertBuilder {
        alertActionSuccessProperties.title = title
        self.onSuccess = onSuccess
        return self
    }
    
    func onCancelAction(title: String, _ onCancel: @escaping ((UIAlertAction) -> Void)) -> AlertBuilder {
        alertActionCancelProperties.title = title
        self.onCancel = onCancel
        return self
    }
    
    @discardableResult
    func showAlert() -> UIAlertController {
        let alert = UIAlertController(title: alertProperties.title, message: alertProperties.message, preferredStyle: alertProperties.preferredStyle)
        
        if let _ = onSuccess {
            alert.addAction(.init(title: alertActionSuccessProperties.title, style: alertActionSuccessProperties.alertActionStyle))
        }
        
        if let _ = onCancel {
            alert.addAction(.init(title: alertActionCancelProperties.title, style: alertActionCancelProperties.alertActionStyle))
        }
        
        viewController.present(alert, animated: true, completion: nil)
        return alert
    }
}
