//
//  MotionData.swift
//  GyroData
//
//  Created by Hamo, inho, Aejong on 2023/01/31.
//

import Foundation

struct MotionData: Hashable {
    let measuredDate: Date
    let duration: Double
    let type: MotionType
    let id: UUID
}
