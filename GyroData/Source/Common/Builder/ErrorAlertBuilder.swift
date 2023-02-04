//
//  ErrorAlertBuilder.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/03.
//

import UIKit

final class ErrorAlertBuilder: AlertBuilder {
    var alert =  UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    func setTitle(_ title: String) -> AlertBuilder {
        alert.title = title
        return self
    }
    
    func setMessage(_ message: String) -> AlertBuilder {
        alert.message = message
        return self
    }
    
    func setAction(
        title: String,
        style: UIAlertAction.Style,
        handler: ((UIAlertAction) -> Void)?
    ) -> AlertBuilder {
        alert.addAction(UIAlertAction(title: title, style: style, handler: handler))
        return self
    }
    
    func makeAlert() -> UIAlertController {
        return alert
    }
}
