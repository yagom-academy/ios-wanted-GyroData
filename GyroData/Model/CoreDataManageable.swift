//
//  CoreDataManageable.swift
//  GyroData
//
//  Created by junho lee on 2023/01/31.
//

protocol CoreDataManageable {
    func readAll() throws -> [MotionData]
    func add(_ motionData: MotionData) throws
    func delete(_ motionData: MotionData) throws
}
