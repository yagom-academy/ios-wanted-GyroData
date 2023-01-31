//
//  MotionData.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import Foundation
import simd

struct MotionData: Codable, Hashable {

    let date: Date
    let type: MotionType
    let time: Double
    let value: [SIMD3<Double>]
    let id: UUID
}
