//
//  MotionType.swift
//  GyroData
//
//  Created by Hamo, inho, Aejong on 2023/01/31.
//

enum MotionType {
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
