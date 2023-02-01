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
    public var errorDescription: String? {
        switch self {
        case .saveFailError(let error):
            return "Data Save Failed with Error: \(error.localizedDescription)"
        case .fetchFailError(let error):
            return "Data fetch Failed with Error: \(error.localizedDescription)"
        case .deleteFailError(let error):
            return "Data delete Failed with Error: \(error.localizedDescription)"
        case .encodingError:
            return "Data Encoding Failed"
        case .decodingError:
            return "Data Decoding Failed"
        case .noDataError(let detail):
            return "there in No Value, detail: \(detail)"
        }
    }
}
