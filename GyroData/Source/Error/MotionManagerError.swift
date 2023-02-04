//
//  MotionManagerError.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/04.
//

import Foundation

enum MotionManagerError: Error {
    case noData
}

extension MotionManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noData:
            return NSLocalizedString("측정 값이 없습니다.", comment: "No Data")
        }
    }
}
