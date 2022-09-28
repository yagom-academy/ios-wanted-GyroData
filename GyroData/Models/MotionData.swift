//
//  MotionData.swift
//  GyroData
//
//  Created by 홍다희 on 2022/09/20.
//

import Foundation

struct MotionData: Codable {
    /// 측정 날짜
    let date: Date
    /// 측정 단위
    let type: MotionType
    /// 측정 값
    var items: [MotionDataItem] = []
    
    var lastTick: TimeInterval {
        return items.last?.tick ?? 0
    }
}

struct MotionDataItem: Codable {
    let tick: TimeInterval
    let x: Double
    let y: Double
    let z: Double
}
