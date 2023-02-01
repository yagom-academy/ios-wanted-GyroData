//
//  Measurement.swift
//  GyroData
//
//  Created by 써니쿠키, 로빈 on 2023/01/30.
//

import Foundation

struct Measurement: Hashable {
    
    let sensor: Sensor
    let date: Date
    let time: Double
    let axisValues: [AxisValue]
}
