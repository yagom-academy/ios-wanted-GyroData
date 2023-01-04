//
//  FileError.swift
//  GyroData
//
//  Created by 천승희 on 2022/12/30.
//

import Foundation

enum FileError: Error {
    case writeError
    case encodeError
    case loadError
    case deleteError
    case parseError
}
