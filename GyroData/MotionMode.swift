//
//  MotionRecord.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/27.
//

enum MotionMode {
    case accelerometer
    case gyroscope

    var name: String {
        switch self {
        case .accelerometer:
            return "Accelerometer"
        case .gyroscope:
            return "Gyro"
        }
    }
}
