//
//  MotionData.swift
//  GyroData
//
//  Created by junho, summercat on 2023/01/30.
//

import Foundation

struct MotionData: Identifiable {
    let id: UUID
    var createdAt: Date
    var length: Double
    var motionDataType: MotionDataType
    var coordinates: [Coordinate]

    init(id: UUID = UUID(),
         createdAt: Date = Date(),
         length: Double = 0,
         motionDataType: MotionDataType,
         coordinates: [Coordinate] = []) {
        self.id = id
        self.createdAt = createdAt
        self.length = length
        self.motionDataType = motionDataType
        self.coordinates = coordinates
    }
}
