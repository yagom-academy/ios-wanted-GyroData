//
//  MotionDataManageable.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/02/03.
//

import CoreMotion

protocol MotionDataManageable {
    
    var motionManager: CMMotionManager { get }
    func configureTimeInterval(_ motion: MotionType, updateInterval: TimeInterval)
    func startUpdates(_ motion: MotionType)
    func stopUpdates(_ motion: MotionType)
}

extension MotionDataManageable {
    
    func configureTimeInterval(_ motion: MotionType, updateInterval: TimeInterval) {
        switch motion {
        case .accelerometer:
            motionManager.accelerometerUpdateInterval = updateInterval
        case .gyro:
            motionManager.gyroUpdateInterval = updateInterval
        }
    }
    
    func stopUpdates(_ motion: MotionType) {
        switch motion {
        case .accelerometer:
            motionManager.stopAccelerometerUpdates()
        case .gyro:
            motionManager.stopGyroUpdates()
        }
    }
}
