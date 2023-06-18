//
//  SixAxisDataForJSON.swift
//  GyroData
//
//  Created by 리지 on 2023/06/12.
//

import Foundation

struct SixAxisDataForJSON: Codable {
    let id: UUID?
    var date: Date?
    var title: String?
    var threeAxisValue: [ThreeAxisValue]?
}

struct ThreeAxisValue: Codable {
    var valueX: Double
    var valueY: Double
    var valueZ: Double
}
