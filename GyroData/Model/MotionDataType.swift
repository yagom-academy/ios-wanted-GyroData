//
//  MotionDataType.swift
//  GyroData
//
//  Created by junho, summercat on 2023/01/30.
//

enum MotionDataType: String, CustomStringConvertible {
    case accelerometer
    case gyro

    var description: String {
        switch self {
        case .accelerometer:
            return "Accelerometer"
        case .gyro:
            return "Gyro"
        }
    }
}
