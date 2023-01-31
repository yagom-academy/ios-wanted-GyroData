//
//  DataStorageType.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

protocol DataStorageType {
    func read(_ fileName: String) throws -> MotionData
    func save(_ data: MotionData) throws
    func delete(_ fileName: String) throws
}
