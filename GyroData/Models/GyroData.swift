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
    let type: Unit
    /// 측정 값
    var lastTick: TimeInterval? {
        return items.last?.tick
    }
    
    var items: [MotionDetailData] = []

    enum Unit: String, Codable {
        case acc = "Accelerometer"
        case gyro = "Gyro"
    }
}

extension GyroData {
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: self.date)
    }
}

struct MotionDetailData: Codable {
    let tick: TimeInterval
    let x: Double
    let y: Double
    let z: Double
}
