//
//  DataHandleError.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/02/01.
//

import Foundation

enum DataHandleError: Error {
    
    case saveFailError(error: Error)
    case fetchFailError(error: Error)
    case deleteFailError(error: Error)
    case encodingError
    case decodingError
    case noDataError(detail: String)
}

extension DataHandleError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .saveFailError(let error):
            return "저장에 실패했습니다. \n Error: \(error.localizedDescription)"
        case .fetchFailError(let error):
            return "로딩에 실패했습니다. \n Error: \(error.localizedDescription)"
        case .deleteFailError(let error):
            return "삭제에 실패했습니다. \n Error: \(error.localizedDescription)"
        case .encodingError:
            return "Data Encoding 과정에 문제가 있습니다."
        case .decodingError:
            return "Data Decoding 과정에 문제가 있습니다."
        case .noDataError(let detail):
            return detail
        }
    }
}
