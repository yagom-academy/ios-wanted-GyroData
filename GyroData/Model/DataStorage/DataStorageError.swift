//
//  DataStorageError.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

enum DataStorageError: Error {
    case cannotFindDirectory
    case cannotFindDocumentDirectory
    case cannotCreateDirectory
    case cannotSaveFile
    case cannotEncodeData
    case cannotDecodeData
    
    var localizedDescription: String {
        switch self {
        case .cannotFindDirectory:
            return "디렉토리를 찾을 수 없습니다."
        case .cannotFindDocumentDirectory:
            return "기본 디렉토리를 찾을 수 없습니다."
        case .cannotCreateDirectory:
            return "디렉토리 생성 실패"
        case .cannotSaveFile:
            return "데이터 저장 실패"
        case .cannotEncodeData:
            return "데이터 인코딩 실패"
        case .cannotDecodeData:
            return "데이터 디코딩 실패"
        }
    }
}
