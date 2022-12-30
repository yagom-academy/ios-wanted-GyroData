//
//  Motion.swift
//  GyroData
//
//  Created by Ari on 2022/12/26.
//

import Foundation
import CoreMotion

// MARK: - Motion
struct Motion {
    
    let uuid: UUID
    let type: MotionType
    let values: [MotionValue]
    let date: Date
    let duration: TimeInterval
    
}

extension Motion {
    
    func toFile() -> MotionList {
        return .init(uuid: self.uuid, values: self.values)
    }
    
}

// MARK: - MotionValue
struct MotionValue: Codable {
    
    let timestamp: TimeInterval
    let x: Double
    let y: Double
    let z: Double
    
}

extension MotionValue {
    
    init(_ data: CMAccelerometerData) {
        self.timestamp = data.timestamp
        self.x = data.acceleration.x
        self.y = data.acceleration.y
        self.z = data.acceleration.z
    }
    
    init(_ data: CMGyroData) {
        self.timestamp = data.timestamp
        self.x = data.rotationRate.x
        self.y = data.rotationRate.y
        self.z = data.rotationRate.z
    }
    
}

// MARK: - MotionType
enum MotionType: Int, Codable {

    case accelerometer = 0
    case gyro = 1

    var title: String {
        switch self {
        case .accelerometer:
            return "Accelerometer"
        case .gyro:
            return "Gyro"
        }
    }
    
    var segmentTitle: String {
        switch self {
        case .accelerometer:
            return "Acc"
        case .gyro:
            return "Gyro"
        }
    }
}
