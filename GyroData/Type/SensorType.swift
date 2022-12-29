//
//  Segment.swift
//  GyroData
//
//  Created by 정재근 on 2022/12/26.
//

import Foundation

enum SensorType: String {
    case accelerometer = "Acc"
    case gyro = "Gyro"
    
    var index: Int {
        switch self {
        case .accelerometer:
            return 0
        case .gyro:
            return 1
        }
    }
    
    var max: CGFloat {
        switch self {
        case .accelerometer:
            return CGFloat(3)
        case .gyro:
            return CGFloat(9)
        }
    }
}
