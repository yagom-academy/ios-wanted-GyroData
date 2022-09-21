//
//  MotionInfo.swift
//  GyroData
//
//  Created by Subin Kim on 2022/09/21.
//

import Foundation

struct MotionInfo: Codable {
    let date: String
    let dataType: String
    let measureTime: String
    let motionX: [Double]
    let motionY: [Double]
    let motionZ: [Double]
}
