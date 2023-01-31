//
//  CoreDataManageable.swift
//  GyroData
//
//  Created by junho lee on 2023/01/31.
//

import Foundation

protocol CoreDataManageable {
    func read(offset: Int, limit: Int) throws -> [MotionDataEntity]
    func save(_ motionData: MotionData) throws
    func delete(_ id: UUID) throws
}
