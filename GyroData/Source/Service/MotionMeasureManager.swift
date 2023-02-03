//
//  MotionMeasureManager.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/01.
//

import CoreMotion
import Foundation

final class GyroMotionManager: MotionManagerable {
    private let motionManager = CMMotionManager()
    private let measureTimer: MeasureTimer
    
    init(duration: Double, interval: TimeInterval) {
        measureTimer = MeasureTimer(duration: duration, interval: interval)
        configureUpdateInterval(interval)
    }
    
    func start(handler: @escaping (MotionCoordinate) -> Void) {
        motionManager.startAccelerometerUpdates()
        measureTimer.activate { [weak self] in
            guard let coordinate = self?.createGyroCoordinate() else { return }
            handler(coordinate)
        }
    }

    func stop() {
        motionManager.stopGyroUpdates()
        measureTimer.stop()
    }
    
    private func configureUpdateInterval(_ interval: TimeInterval) {
        motionManager.gyroUpdateInterval = interval
    }
    
    private func createGyroCoordinate() -> MotionCoordinate? {
        guard let measureData =  motionManager.accelerometerData?.acceleration else {
            return nil
        }
        
        let coordinate = MotionCoordinate(x: measureData.x, y: measureData.y, z: measureData.z)
        return coordinate
    }
}

final class AccelerometerMotionManager: MotionManagerable {
    private let motionManager = CMMotionManager()
    private let measureTimer: MeasureTimer
    
    init(duration: Double, interval: TimeInterval) {
        measureTimer = MeasureTimer(duration: duration, interval: interval)
        configureUpdateInterval(interval)
    }
    
    func start(handler: @escaping (MotionCoordinate) -> Void) {
        motionManager.startAccelerometerUpdates()
        measureTimer.activate { [weak self] in
            guard let coordinate = self?.createAccelerometerCoordinate() else { return }
            handler(coordinate)
        }
    }
    
    func stop() {
        motionManager.stopAccelerometerUpdates()
        measureTimer.stop()
    }
    
    private func configureUpdateInterval(_ interval: TimeInterval) {
        motionManager.accelerometerUpdateInterval = interval
    }
    
    private func createAccelerometerCoordinate() -> MotionCoordinate? {
        guard let measureData =  motionManager.accelerometerData?.acceleration else {
            return nil
        }
        
        let coordinate = MotionCoordinate(x: measureData.x, y: measureData.y, z: measureData.z)
        return coordinate
    }
}
