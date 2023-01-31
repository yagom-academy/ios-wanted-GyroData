//
//  GyroModel.swift
//  GyroData
//
//  Created by Mangdi on 2023/01/31.
//

import Foundation

struct TransitionMetaData: Identifiable {
    let id: UUID
    let saveDate: String
    let sensorType: SensorType
    let recordTime: Double
    let jsonName: String

    init(id: UUID = UUID(),
         saveDate: String,
         sensorType: SensorType,
         recordTime: Double,
         jsonName: String) {
        self.id = id
        self.saveDate = saveDate
        self.sensorType = sensorType
        self.recordTime = recordTime
        self.jsonName = jsonName
    }
}

enum SensorType: String {
    case Accelerometer = "Accelerometer"
    case Gyro = "Gyro"
}
