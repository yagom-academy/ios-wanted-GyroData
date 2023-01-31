//
//  FileManageable.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/31.
//

import Foundation

protocol FileManageable {
    func save(_ data: MeasureData) throws
    func fetch(date: Date) throws -> Data
    func delete(_ date: Date) throws
}
