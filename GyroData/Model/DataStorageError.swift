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
}
