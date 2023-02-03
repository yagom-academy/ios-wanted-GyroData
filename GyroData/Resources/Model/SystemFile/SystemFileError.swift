//
//  FileReadError.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

enum FileReadError: Error {
    case invalidURL
    case decodeData
    case decodeJson
}
