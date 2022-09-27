//
//  MotionInfo.swift
//  GyroData
//
//  Created by Subin Kim on 2022/09/21.
//

import Foundation

struct MotionInfo: Codable {
    var date: String = ""
    var dataType: String = ""
    var measureTime: String = ""
    var motionX: [Double] = []
    var motionY: [Double] = []
    var motionZ: [Double] = []
}
