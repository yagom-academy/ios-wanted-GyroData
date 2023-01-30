//
//  GyroModel.swift
//  GyroData
//
//  Created by Mangdi on 2023/01/31.
//

import Foundation

struct GyroModel: Identifiable {
    let id: UUID
    let saveDate: String
    let sensorType: SensorType
    let recordTime: Double
    let jsonName: String
}

enum SensorType: String {
    case Accelerometer = "Accelerometer"
    case Gyro = "Gyro"
}
