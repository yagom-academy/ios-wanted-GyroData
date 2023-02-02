//
//  MotionMeasureManager.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/01.
//

import CoreMotion
import Foundation

protocol MotionManagerable {
    func start(handler: @escaping () -> Void)
    func stop()
}

final class GyroMotionManager: MotionManagerable {
    private let motionManager = CMMotionManager()
    
    init(interval: TimeInterval) {
        configureUpdateInterval(interval)
    }
    
    func start(handler: @escaping () -> Void) {
        motionManager.startAccelerometerUpdates()
    }

    func stop() {
        motionManager.stopGyroUpdates()
    }
    
    private func configureUpdateInterval(_ interval: TimeInterval) {
        motionManager.gyroUpdateInterval = interval
    }
}

final class AccelerometerMotionManager: MotionManagerable {
    private let motionManager = CMMotionManager()
    
    init(interval: TimeInterval) {
        configureUpdateInterval(interval)
    }
    
    func start(handler: @escaping () -> Void) {
        motionManager.startAccelerometerUpdates()
    }
    
    func stop() {
        motionManager.stopAccelerometerUpdates()
    }
    
    private func configureUpdateInterval(_ interval: TimeInterval) {
        motionManager.gyroUpdateInterval = interval
    }
}
