//
//  SixAxisData.swift
//  GyroData
//
//  Created by 리지 on 2023/06/12.
//

import Foundation

struct SixAxisData: Codable {
    let id: UUID
    var date: String?
    var title: String?
    var accelerometer: [ThreeAxisValue]?
    var gyroscope: [ThreeAxisValue]?
}

struct ThreeAxisValue: Codable {
    var valueX: Double
    var valueY: Double
    var valueZ: Double
}
