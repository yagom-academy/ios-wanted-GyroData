//
//  MotionMeasureManager.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/01.
//

import CoreMotion
import Foundation

final class AccelerometerMotionManager: MotionManagerable {
    private let motionManager = CMMotionManager()
    private let fileHandleManager = FileHandleManager()
    private let measureTimer: MeasureTimer
    private var motionData: MotionData?
    private var measuredMotion: MotionMeasures?
    
    init(deadline: Double, interval: TimeInterval) {
        measureTimer = MeasureTimer(deadline: deadline, interval: interval)
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
