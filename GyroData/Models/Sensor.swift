//
//  Sensor.swift
//  GyroData
//
//  Created by 써니쿠키, 로빈 on 2023/01/30.
//

import Foundation

enum Sensor: Int, Hashable, Codable {
    
    case Accelerometer
    case Gyro
    
    var name: String {
        switch self {
        case .Accelerometer:
            return "Accelerometer"
        case .Gyro:
            return "Gyro"
        }
    }
}
