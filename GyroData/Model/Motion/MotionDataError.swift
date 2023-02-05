//
//  MotionDataError.swift
//  GyroData
//
//  Created by summercat on 2023/02/01.
//

import Foundation

enum MotionDataError: Error {
    case emptyData
    
    var localizedDescription: String {
        switch self {
        case .emptyData:
            return "측정된 데이터가 없어 저장에 실패했습니다."
        }
    }
}
