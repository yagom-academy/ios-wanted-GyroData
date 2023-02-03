//
//  AlertDirector.swift
//  GyroData
//
//  Created by parkhyo on 2023/02/03.
//

import UIKit

final class AlertDirector {
    func setupErrorAlert(builder: AlertBuilder, errorMessage: String) -> UIAlertController {
        let alert = builder
            .setTitle("오류")
            .setMessage(errorMessage)
            .setAction(title: "취소", style: .cancel, handler: nil)
            .makeAlert()
            
        return alert
    }
}
