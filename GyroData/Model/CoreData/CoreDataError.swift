//
//  CoreDataError.swift
//  GyroData
//
//  Created by summercat on 2023/02/01.
//

import Foundation

enum CoreDataError: Error {
    case cannotReadData
    case cannotSaveData
    case cannotDeleteData
    
    var localizedDescription: String {
        switch self {
        case .cannotReadData:
            return "데이터 불러오기 실패"
        case .cannotSaveData:
            return "데이터 저장 실패"
        case .cannotDeleteData:
            return "데이터 삭제 실패"
        }
    }
}
