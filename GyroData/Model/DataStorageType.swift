//
//  DataStorageType.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

protocol DataStorageType {
    func read(with fileName: String) throws -> MotionData
    func save(_ data: MotionData) throws
    func delete(with fileName: String) throws
}
