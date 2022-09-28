//
//  MotionFile.swift
//  GyroData
//
//  Created by channy on 2022/09/22.
//

import Foundation

struct MotionFile: Codable {
    let fileName: String
    let type: String
    let x_axis: [Float]
    let y_axis: [Float]
    let z_axis: [Float]
}
