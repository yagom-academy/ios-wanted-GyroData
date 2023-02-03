//
//  FileSystemError.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/31.
//

import Foundation

enum FileSystemError: Error {
    case encodeError
    case saveError
    case loadError
    case deleteError
    case unknownError
}

extension FileSystemError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .encodeError:
            return "인코딩 오류입니다."
        case .saveError:
            return "저장 실패하였습니다."
        case .loadError:
            return "데이터 불러오기 실패하였습니다."
        case .deleteError:
            return "삭제 실패하였습니다."
        case .unknownError:
            return "오류 발생하였습니다."
        }
    }
}
