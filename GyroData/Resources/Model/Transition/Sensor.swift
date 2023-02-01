//
//  Sensor.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.

enum SensorType: String {
    case Accelerometer = "Accelerometer"
    case Gyro = "Gyro"
}

extension SensorType {
    init?(rawInt: Int) {
        switch rawInt {
        case 0:
            self.init(rawValue: "Accelerometer")
            
        case 1:
            self.init(rawValue: "Gyro")
            
        default:
            return nil
        }
    }
}
