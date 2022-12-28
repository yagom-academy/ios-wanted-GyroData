//
//  MotionData.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/29.
//

import Foundation

struct MotionData {
    let id: UUID
    let motionType: MotionType
    let date: Date
    let time: Double
    let xData: [Double]
    let yData: [Double]
    let zData: [Double]
}
