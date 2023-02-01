//
//  FileManagingError.swift
//  GyroData
//
//  Created by Aejong on 2023/02/01.
//

enum FileManagingError: Error {
    case encodeFailed
    case decodeFailed
    case createDirectoryFailed
    case saveFailed
    case loadFailed
    case deleteFailed
}
