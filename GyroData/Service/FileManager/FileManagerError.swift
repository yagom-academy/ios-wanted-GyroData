//
//  FileManagerError.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/30.
//

import Foundation

enum FileManagerError: LocalizedError {
    case save
    case delete
    case fetch
    
    var errorDescription: String? {
        switch self {
        case .save:
            return "저장에 실패하였습니다."
        case .delete:
            return "삭제에 실패하였습니다."
        case .fetch:
            return "파일 불러오는데 실패하였습니다."
        }
    }
}
