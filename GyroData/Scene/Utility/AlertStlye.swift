//
//  AlertStyle.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/02/02.
//

import UIKit

enum AlertStyle {
    case motionCreatingFailed
    case insufficientDataToCreate
    
    var title: String {
        switch self {
        case .motionCreatingFailed:
            return "저장 실패"
        case .insufficientDataToCreate:
            return "저장 실패"
        }
    }
    
    var message: String {
        switch self {
        case .motionCreatingFailed:
            return "저장에 실패했습니다."
        case .insufficientDataToCreate:
            return "저장할 데이터가 없습니다."
        }
    }
}
