//
//  CoreDataError.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/30.
//

import Foundation

enum CoreDataError: Error {
    case invalidData
}

extension CoreDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "유효하지 않은 값입니다."
        }
    }
}
