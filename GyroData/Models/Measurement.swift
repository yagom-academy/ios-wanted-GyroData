//
//  Measurement.swift
//  GyroData
//
//  Created by 써니쿠키, 로빈 on 2023/01/30.
//

import Foundation

struct Measurement: Hashable, Codable {
    
    let sensor: Sensor
    let date: Date
    var time: Double
    var axisValues: [AxisValue]
}
