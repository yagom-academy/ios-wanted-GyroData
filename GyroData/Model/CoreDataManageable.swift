//
//  CoreDataManageable.swift
//  GyroData
//
//  Created by junho lee on 2023/01/31.
//

protocol CoreDataManageable {
    func readAll() -> [MotionData]
    func add(_ motionData: MotionData)
    func delete(_ motionData: MotionData)
}
