//
//  MotionData.swift
//  GyroData
//
//  Created by 유한석 on 2022/12/27.
//

import Foundation

struct MotionData: Codable {
    var path: String
    var measuredData: [MeasureData]
}
