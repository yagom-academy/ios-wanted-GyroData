//
//  AlertManager.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/17.
//

import UIKit

struct AlertManager {
    func createErrorAlert(error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "데이터 저장에 실패하였습니다.",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .destructive)
        
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
