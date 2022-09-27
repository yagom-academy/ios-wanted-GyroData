//
//  MotionType.swift
//  GyroData
//
//  Created by 신병기 on 2022/09/25.
//

enum MotionType: Int, Codable {
    case acc = 0
    case gyro = 1
}

extension MotionType {
    var displayText: String {
        switch self {
        case .acc:
            return "Accelerometer"
        case .gyro:
            return "Gyro"
        }
    }
}
