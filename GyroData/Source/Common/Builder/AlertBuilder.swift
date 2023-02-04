//
//  AlertBuilder.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/03.
//

import UIKit

protocol AlertBuilder {
    var alert: UIAlertController { get }
    func setTitle(_ title: String) -> AlertBuilder
    func setMessage(_ message: String) -> AlertBuilder
    func setAction(
        title: String,
        style: UIAlertAction.Style,
        handler: ((UIAlertAction) -> Void)?
    ) -> AlertBuilder
    func makeAlert() -> UIAlertController
}
