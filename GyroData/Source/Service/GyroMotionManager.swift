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
    var timeOverHandler: ((Bool) -> Void)?
    
    init(deadline: Double, interval: TimeInterval) {
        measureTimer = MeasureTimer(deadline: deadline, interval: interval)
        measureTimer.delegate = self
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
            type: .gyroscope,
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
    func start(handler: @escaping (MotionCoordinate?) -> Void) {
        initialMotionData()
        motionManager.startGyroUpdates()
        measureTimer.activate { [weak self] in
            guard let measureData =  self?.motionManager.gyroData?.rotationRate else {
                return
            }
            self?.measuredMotion?.axisX.append(measureData.x)
            self?.measuredMotion?.axisY.append(measureData.y)
            self?.measuredMotion?.axisZ.append(measureData.z)
            handler(MotionCoordinate(x: measureData.x, y: measureData.y, z: measureData.z))
        }
    }

    func stop() {
        motionManager.stopGyroUpdates()
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
extension GyroMotionManager: MeasureTimerDelegate {
    func timeOver(duration: Double) {
        motionManager.stopGyroUpdates()
        createMotionData(duration: duration)
        timeOverHandler?(true)
    }
}
