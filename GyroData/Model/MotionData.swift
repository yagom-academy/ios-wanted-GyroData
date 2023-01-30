//
//  MotionData.swift
//  GyroData
//
//  Created by junho, summercat on 2023/01/30.
//

import Foundation

struct MotionData {
    var createdAt: Date
    var length: Double
    var motionDataType: MotionDataType
    var coordinates: [Coordinate]
}
