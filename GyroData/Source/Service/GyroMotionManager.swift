//
//  GyroMotionManager.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/04.
//

import CoreMotion
import Foundation

final class GyroMotionManager: MotionManagerable {
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
        motionManager.gyroUpdateInterval = interval
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
    
    private func initialMotionData() {
        motionData = nil
        measuredMotion = MotionMeasures(axisX: [], axisY: [], axisZ: [])
    }
}

// MARK: MotionManagerable Requirement
extension GyroMotionManager {
    func start(handler: @escaping (MotionMeasures?) -> Void) {
        initialMotionData()
        motionManager.startAccelerometerUpdates()
        measureTimer.activate { [weak self] in
            guard let measureData =  self?.motionManager.gyroData?.rotationRate else {
                return
            }
            self?.measuredMotion?.axisX.append(measureData.x)
            self?.measuredMotion?.axisY.append(measureData.y)
            self?.measuredMotion?.axisZ.append(measureData.z)
            handler(self?.measuredMotion)
        }
    }

    func stop() {
        motionManager.stopGyroUpdates()
        let duration = measureTimer.stop()
        createMotionData(duration: duration)
    }

    func save(completionHandler: @escaping () -> Void) {
        
    }
}
