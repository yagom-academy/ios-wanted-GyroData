//
//  MotionData.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/29.
//

import Foundation

struct Motion: Codable {
    let motion: MotionInformation
    let xData: [Double]
    let yData: [Double]
    let zData: [Double]
}
