//
//  MotionType.swift
//  GyroData
//
//  Created by Hamo, inho, Aejong on 2023/01/31.
//


enum MotionType: String {
    case accelerometer = "Acc"
    case gyroscope = "Gyro"
}

extension MotionType {
    var description: String {
        switch self {
        case .accelerometer:
            return "Accelerometer"
        case .gyroscope:
            return "Gyro"
        }
    }
}
