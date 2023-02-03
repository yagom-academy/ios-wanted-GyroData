//
//  UploadError.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

enum UploadError: Error {
    case urlCreationFailed
    case jsonUploadFailed
    case coreDataUploadFailed
    
    var alertTitle: String {
        switch self {
        case .urlCreationFailed:
            return "파일 생성 오류"
        case .jsonUploadFailed:
            return "파일 업로드 오류"
        case .coreDataUploadFailed:
            return "데이터 업로드 오류"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .urlCreationFailed:
            return "파일을 생성하는 도중 예기치 못한 오류가 발생하였습니다. 잠시 후 다시 시도해주세요."
        case .jsonUploadFailed:
            return "파일을 업로드하는 도중 예기치 못한 오류가 발생하였습니다. 잠시 후 다시 시도해주세요."
        case .coreDataUploadFailed:
            return "데이터를 업로드하는 도중 예기치 못한 오류가 발생하였습니다. 잠시 후 다시 시도해주세요."
        }
    }
}
