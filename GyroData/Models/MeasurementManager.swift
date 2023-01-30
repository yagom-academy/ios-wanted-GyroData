//
//  MeasurementManager.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/30.
//

class MeasurementManager {
    private let accelerometerManager = AccelerometerManager()
    private let gyroManager = GyroManager()

    func measure(sensor: Sensor) {
        switch sensor {
        case .Gyro:
            gyroManager.measure()
        case .Accelerometer:
            accelerometerManager.measure()
        }
    }

    func stop(sensor: Sensor) {
        switch sensor {
        case .Gyro:
            gyroManager.stop()
        case .Accelerometer:
            accelerometerManager.stop()
        }
    }
}
