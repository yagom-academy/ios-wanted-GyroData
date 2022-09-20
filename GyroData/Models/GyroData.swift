//
//  GyroData.swift
//  GyroData
//
//  Created by 홍다희 on 2022/09/20.
//

import Foundation

struct GyroData {
    /// 측정 날짜
    private let date: Date
    /// 측정 단위
    let type: Unit
    /// 측정 값
    let value: Double

    enum Unit: String {
        case acc = "Accelerometer"
        case gyro = "Gyro"
    }

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: self.date)
    }
}

extension GyroData {
    static func sampleData() -> [GyroData] {
        return [
            .init(date: Date(), type: .acc, value: 43.4),
            .init(date: Date() + 60*60, type: .gyro, value: 60.0),
            .init(date: Date() + 60*30, type: .acc, value: 30.4),
            .init(date: Date(), type: .acc, value: 43.4),
            .init(date: Date() + 60*60, type: .gyro, value: 60.0),
            .init(date: Date() + 60*30, type: .acc, value: 30.4),
            .init(date: Date(), type: .acc, value: 43.4),
            .init(date: Date() + 60*60, type: .gyro, value: 60.0),
            .init(date: Date() + 60*30, type: .acc, value: 30.4),
            .init(date: Date(), type: .acc, value: 43.4),
            .init(date: Date() + 60*60, type: .gyro, value: 60.0),
            .init(date: Date() + 60*30, type: .acc, value: 30.4),
            .init(date: Date(), type: .acc, value: 43.4),
            .init(date: Date() + 60*60, type: .gyro, value: 60.0),
            .init(date: Date() + 60*30, type: .acc, value: 30.4),
            .init(date: Date(), type: .acc, value: 43.4),
            .init(date: Date() + 60*60, type: .gyro, value: 60.0),
            .init(date: Date() + 60*30, type: .acc, value: 30.4),
            .init(date: Date(), type: .acc, value: 43.4),
            .init(date: Date() + 60*60, type: .gyro, value: 60.0),
            .init(date: Date() + 60*30, type: .acc, value: 30.4),
        ]
    }
}
