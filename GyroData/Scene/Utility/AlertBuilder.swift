//
//  AlertBuilder.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/02/04.
//

import UIKit

final class AlertBuilder {
    private var title: String?
    private var message: String?
    private var style: UIAlertController.Style = .alert
    private var actions: [UIAlertAction] = []
    private let defaultActions: [UIAlertAction] = [
        UIAlertAction(title: "확인", style: .default)
    ]
    
    func withTitle(_ title: String) -> AlertBuilder {
        self.title = title
        return self
    }
    
    func withMessage(_ message: String) -> AlertBuilder {
        self.message = message
        return self
    }
    
    func withStyle(_ style: UIAlertController.Style) -> AlertBuilder {
        self.style = style
        return self
    }
    
    func withAction(
        title: String? = nil,
        style: UIAlertAction.Style,
        handler: ((UIAlertAction) -> Void)? = nil
    ) -> AlertBuilder {
        actions.append(UIAlertAction(title: title, style: style, handler: handler))
        return self
    }
    
    func withDefaultActions() -> AlertBuilder {
        actions = defaultActions
        return self
    }
    
    func build() -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach(alertController.addAction(_:))
        return alertController
    }
}
