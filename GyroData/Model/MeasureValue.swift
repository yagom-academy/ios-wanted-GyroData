//
//  MeasureInfo.swift
//  GyroData
//
//  Created by 천승희 on 2022/12/30.
//

import Foundation

struct MeasureValue: Codable {
    var measureDate: String
    var sensorType: String
    var measureTime: String
    var xData: [Double]
    var yData: [Double]
    var zData: [Double] 
}
