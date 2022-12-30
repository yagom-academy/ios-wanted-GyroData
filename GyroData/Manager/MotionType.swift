//
//  MotionType.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/27.
//

enum MotionType {
    case accelerometer
    case gyro
}

extension MotionType {
    var codeName: String {
        switch self {
        case .accelerometer:
            return "accelerometer"
        case .gyro:
            return "gyro"
        }
    }
}
