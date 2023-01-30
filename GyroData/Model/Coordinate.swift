//
//  Coordinate.swift
//  GyroData
//
//  Created by junho, summercat on 2023/01/30.
//

import CoreMotion

struct Coordinate {
    var x: Double
    var y: Double
    var z: Double

    init(_ value: CMAcceleration) {
        self.x = value.x
        self.y = value.y
        self.z = value.z
    }

    init(_ value: CMRotationRate) {
        self.x = value.x
        self.y = value.y
        self.z = value.z
    }
}
