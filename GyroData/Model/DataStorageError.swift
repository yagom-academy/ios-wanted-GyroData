//
//  DataStorageError.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

enum DataStorageError: Error {
    case cannotFindDocumentDirectory
    case cannotCreateDirectory
    case cannotReadFile
    case cannotSaveFile
    case cannotDeleteData
    case cannotEncodeData
    case cannotDecodeData
}
