//
//  MotionDataType.swift
//  GyroData
//
//  Created by Wonbi on 2023/01/31.
//

import Foundation

protocol MotionDataType {
    var x: Double { get set }
    var y: Double { get set }
    var z: Double { get set }
}

extension MotionDataType {
    var xDescription: String {
        return String(round(x * 10000) / 10000)
    }
    var yDescription: String {
        return String(round(y * 10000) / 10000)
    }
    var zDescription: String {
        return String(round(z * 10000) / 10000)
    }
}
