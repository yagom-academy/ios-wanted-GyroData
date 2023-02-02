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
    private let measureTimer: MeasureTimer
    
    init(duration: Double, interval: TimeInterval) {
        measureTimer = MeasureTimer(duration: duration, interval: interval)
        configureUpdateInterval(interval)
    }
    
    func start(handler: @escaping () -> Void) {
        motionManager.startAccelerometerUpdates()
        measureTimer.activate {
            handler()
        }
    }

    func stop() {
        motionManager.stopGyroUpdates()
        measureTimer.stop()
    }
    
    private func configureUpdateInterval(_ interval: TimeInterval) {
        motionManager.gyroUpdateInterval = interval
    }
}

final class AccelerometerMotionManager: MotionManagerable {
    private let motionManager = CMMotionManager()
    private let measureTimer: MeasureTimer
    
    init(duration: Double, interval: TimeInterval) {
        measureTimer = MeasureTimer(duration: duration, interval: interval)
        configureUpdateInterval(interval)
    }
    
    func start(handler: @escaping () -> Void) {
        motionManager.startAccelerometerUpdates()
        measureTimer.activate {
            handler()
        }
    }
    
    func stop() {
        motionManager.stopAccelerometerUpdates()
        measureTimer.stop()
    }
    
    private func configureUpdateInterval(_ interval: TimeInterval) {
        motionManager.gyroUpdateInterval = interval
    }
}
