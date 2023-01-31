//
//  DataManageable.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/31.
//

import Foundation

protocol DataManageable {
    func save(_ model: MeasureData) throws
    func fetch(offset: Int, limit: Int) throws -> [MeasureData]
    func delete(_ date: Date) throws
}
