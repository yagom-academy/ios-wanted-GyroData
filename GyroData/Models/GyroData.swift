//
//  GyroData.swift
//  GyroData
//
//  Created by 홍다희 on 2022/09/20.
//

import Foundation

struct GyroData: Codable {
    /// 측정 날짜
    let date: Date
    /// 측정 단위
    let type: MotionType
    /// 측정 값
    var items: [MotionDetailData] = []
    
    var lastTick: TimeInterval {
        return items.last?.tick ?? 0
    }
}

struct MotionDetailData: Codable {
    let tick: TimeInterval
    let x: Double
    let y: Double
    let z: Double
}
