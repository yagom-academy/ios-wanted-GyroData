//
//  Sensor.swift
//  GyroData
//
//  Created by 써니쿠키, 로빈 on 2023/01/30.
//

import Foundation

enum Sensor: Int, Hashable {
    
    case Gyro
    case Accelerometer
    
    var name: String {
        switch self {
        case .Gyro:
            return "Gyro"
        case .Accelerometer:
            return "Accelerometer"
        }
    }
}
