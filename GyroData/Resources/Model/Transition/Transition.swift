//
//  Transition.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.
        

import Foundation

typealias TransitionValue = (Double, Double, Double)

struct Transition: Codable {
    let values: [Tick]
}

struct Tick: Codable {
    let x: Double
    let y: Double
    let z: Double
}

extension Tick {
    func convert(with sensor: SensorType = .Accelerometer) -> Self {
        switch sensor {
        case .Accelerometer:
            return Tick(x: self.x * 20, y: self.y * 20, z: self.z * 20)
        case .Gyro:
            return self
        }
        
    }
}
