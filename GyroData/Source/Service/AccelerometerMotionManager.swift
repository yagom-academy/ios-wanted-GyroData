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
    
    private func createMotionData(duration: Double) {
        let measuredData = Date(timeInterval: -duration, since: Date())
        
        motionData = MotionData(
            measuredDate: measuredData,
            duration: duration,
            type: .accelerometer,
            id: UUID()
        )
    }
}

// MARK: MotionManagerable Requirement
extension AccelerometerMotionManager {
    func start(handler: @escaping (MotionMeasures?) -> Void) {
        motionManager.startAccelerometerUpdates()
        measureTimer.activate { [weak self] in
            guard let measureData =  self?.motionManager.accelerometerData?.acceleration else {
                return
            }
            
            self?.measuredMotion?.axisX.append(measureData.x)
            self?.measuredMotion?.axisY.append(measureData.y)
            self?.measuredMotion?.axisZ.append(measureData.z)
            handler(self?.measuredMotion)
        }
    }
    
    func stop() {
        motionManager.stopAccelerometerUpdates()
        let duration = measureTimer.stop()
        createMotionData(duration: duration)
    }
    
    func save(completionHandler: @escaping () -> Void) {
        
    }
}
