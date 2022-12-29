//
//  MotionMeasurementNumber.swift
//  GyroData
//
//  Created by Judy on 2022/12/29.
//

import CoreMotion

protocol Measurementable {
    var x: Double { get }
    var y: Double { get }
    var z: Double { get }
}

extension CMAcceleration: Measurementable { }
extension CMRotationRate: Measurementable { }
