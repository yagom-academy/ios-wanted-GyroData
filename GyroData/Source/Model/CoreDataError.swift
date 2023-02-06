//
//  CoreDataError.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/02/01.
//

import Foundation

enum CoreDataError: Error {
    case readError
}

extension CoreDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .readError:
            return NSLocalizedString("readError", comment: "데이터 로드에 실패했습니다.")
        }
    }
}
