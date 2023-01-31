//
//  SensorData.swift
//  GyroData
//
//

import Foundation

struct Measurement {
    let sensor: Sensor
    let value: [AxisData]
    let time: Double
    let date: Date
}
