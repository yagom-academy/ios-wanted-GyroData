//
//  SensorData.swift
//  GyroData
//
//  Created by brad on 2022/12/26.
//

import Foundation

struct MeasuredData {
    let uuid = UUID()
    let date: Date
    let measuredTime: Double
    
    let sensorData: SensorData
}

struct SensorData {
    let sensor: Sensor
    
    let AxisX: [Double]
    let AxisY: [Double]
    let AxisZ: [Double]
}
