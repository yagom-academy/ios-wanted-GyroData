//
//  MeasureData.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/30.
//

import Foundation

struct MeasureData: Codable, Hashable {
    var xValue: [Double]
    var yValue: [Double]
    var zValue: [Double]
    let runTime: Double
    let date: Date
    var type: Sensor?
}
