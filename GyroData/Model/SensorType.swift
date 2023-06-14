//
//  SensorType.swift
//  GyroData
//
//  Created by 리지 on 2023/06/12.
//

enum SensorType: CustomStringConvertible {
    case accelerometer
    case gyroscope
    
    var description: String {
        switch self {
        case .accelerometer:
           return "Accelerometer"
        case .gyroscope:
           return "Gyro"
        }
    }
}
