//
//  MeasureData.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/30.
//

import Foundation

struct MeasureData: Codable {
    enum Sensor: Int, Codable {
        case accelerometer
        case gyroscope
    }
    
    let xValue: [Double]
    let yValue: [Double]
    let zValue: [Double]
    let runTime: Double
    let date: Date
    let type: Sensor?
}
