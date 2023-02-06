//
//  Sensor.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/30.
//

import Foundation

enum Sensor: Int, Codable {
    case accelerometer
    case gyroscope
}

extension Sensor: CustomStringConvertible {
    var description: String {
        switch self {
        case .accelerometer:
            return "Accelerometer"
        case .gyroscope:
            return "Gyro"
        }
    }
}
