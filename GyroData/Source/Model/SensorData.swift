//  GyroData - MeasureData.swift
//  Created by zhilly, woong on 2023/02/01

import Foundation

struct MeasureData {
    let date: Date
    let sensor: SensorMode
    var sensorData: SensorData
}

struct SensorData {
    var x: [Double]
    var y: [Double]
    var z: [Double]
}
