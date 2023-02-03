//
//  AlertDirector.swift
//  GyroData
//
//  Created by parkhyo on 2023/02/03.
//

import UIKit

final class AlertDirector {
    func setupErrorAlert(builder: AlertBuilder, title: String, errorMessage: String) -> UIAlertController {
        let alert = builder
            .setTitle(title)
            .setMessage(errorMessage)
            .setAction(title: "확인", style: .default, handler: nil)
            .makeAlert()
            
        return alert
    }
}
