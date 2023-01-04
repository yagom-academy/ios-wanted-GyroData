//
//  AlertManager.swift
//  GyroData
//
//  Created by 정재근 on 2022/12/30.
//

import UIKit

enum AlertType {
    case saveFail
    case saveSuccess(_ viewController: UIViewController)
}

class AlertManager {
    static func alert(title: String, alertType: AlertType) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        switch alertType {
        case .saveFail :
            let yes = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(yes)
        case .saveSuccess(let VC) :
            let yes = UIAlertAction(title: "확인", style: .default, handler: { _ in
                VC.navigationController?.popViewController(animated: true)
            })
            alert.addAction(yes)
        }
        
        return alert
    }
}

