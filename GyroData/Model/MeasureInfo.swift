//
//  MeasureInfo.swift
//  GyroData
//
//  Created by 천승희 on 2022/12/30.
//

import Foundation

struct MeasureInfo: Codable {
    var date: String = ""
    var dataType: String = ""
    var measureTime: String = ""
    var motionX: [Double] = []
    var motionY: [Double] = []
    var motionZ: [Double] = []
}
