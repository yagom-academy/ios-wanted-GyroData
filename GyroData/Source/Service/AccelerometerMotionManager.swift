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
    var timeOverHandler: ((Bool) -> Void)?
    
    init(deadline: Double, interval: TimeInterval) {
        measureTimer = MeasureTimer(deadline: deadline, interval: interval)
        measureTimer.delegate = self
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
    
    private func initialMotionData() {
        motionData = nil
        measuredMotion = MotionMeasures(axisX: [], axisY: [], axisZ: [])
    }
}

// MARK: MotionManagerable Requirement
extension AccelerometerMotionManager {
    func start(handler: @escaping (MotionMeasures?) -> Void) {
        initialMotionData()
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
    
    func save(
        completionHandler: @escaping () -> Void,
        errorHandler: @escaping (Error) -> Void
    ) {
        guard let motionData = motionData,
              let measuredMotion = measuredMotion
        else {
            errorHandler(MotionManagerError.noData)
            return
        }
        
        let saveGroup = DispatchGroup()
        var coreDataError: Error?
        var fileManigingError: Error?
        
        fileHandleManager?.save(
            fileName: motionData.id,
            motionMeasures: measuredMotion,
            dispatchGroup: saveGroup) { result in
                switch result {
                case .success:
                    break
                case .failure(let failure):
                    fileManigingError = failure
                }
            }
        
        saveCoreData(
            motionData: motionData,
            dispatchGroup: saveGroup) { result in
                switch result {
                case .success:
                    break
                case .failure(let failure):
                    coreDataError = failure
                }
            }
        
        
        saveGroup.notify(queue: .main) {
            if let coreDataError = coreDataError {
                errorHandler(coreDataError)
                return
            }
            
            if let fileManigingError = fileManigingError {
                errorHandler(fileManigingError)
                return
            }
            
            completionHandler()
        }
    }
}

// MARK: MeasureTimerDelegate
extension AccelerometerMotionManager: MeasureTimerDelegate {
    func timeOver(duration: Double) {
        createMotionData(duration: duration)
        timeOverHandler?(true)
    }
}
