//
//  SensorData.swift
//  GyroData
//
//  Created by brad on 2022/12/26.
//

import Foundation

struct SensorData {
    let date: Date
    let measuredValue: Double
    let sensor: Sensor
}

enum Sensor {
    case accelerometer
    case gyro
}
