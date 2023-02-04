//  GyroData - FileManagedData.swift
//  Created by zhilly, woong on 2023/02/04

import Foundation

struct FileManagedData: Codable {
    var createdAt: Date
    var runtime: Double
    var sensorData: SensorData
}
