//
//  Sensor.swift
//  GyroData
//
//  Created by 써니쿠키, 로빈 on 2023/01/30.
//

import Foundation

enum Sensor: String, Hashable {
    
    case Gyro = "Gyro"
    case Accelerometer = "Accelerometer"
    
    var name: String {
        return self.rawValue
    }
}
