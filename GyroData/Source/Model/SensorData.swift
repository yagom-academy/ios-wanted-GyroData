//  GyroData - MeasureData.swift
//  Created by zhilly, woong on 2023/02/01

import Foundation

struct SensorData: Hashable, Codable {
    
    var x: [Double]
    var y: [Double]
    var z: [Double]
}
