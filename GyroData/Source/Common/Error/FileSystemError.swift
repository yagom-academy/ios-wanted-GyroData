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
