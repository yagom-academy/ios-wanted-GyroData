//
//  Segment.swift
//  GyroData
//
//  Created by 정재근 on 2022/12/26.
//

import Foundation

enum SensorType: String {
    case acc = "Accelerometer"
    case gyro = "Gyro"
    
    var index: Int {
        switch self {
        case .acc:
            return 0
        case .gyro:
            return 1
        }
    }
    
    var segmentTitle: String {
        switch self {
        case .acc:
            return "Acc"
        case .gyro:
            return "Gyro"
        }
    }
    
    var max: CGFloat {
        switch self {
        case .acc:
            return CGFloat(6)
        case .gyro:
            return CGFloat(18)
        }
    }
}
