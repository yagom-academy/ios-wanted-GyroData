//
//  MotionRecord.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/27.
//

import Foundation

struct MotionRecord {
    let id: UUID
    let startDate: Date
    let msInterval: Int
    let motionMode: MotionMode
    let coordinates: [Coordiante]
}
