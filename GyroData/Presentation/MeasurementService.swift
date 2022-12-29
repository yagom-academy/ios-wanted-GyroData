//
//  MeasurementService.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/27.
//

import CoreMotion

class MeasurementService {
    private let manager = CMMotionManager()
    private(set) var timer = Timer()
    private var measuredDataList = [[Double]]()

    func measureAccelerometer() {
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        
        var second = 0
        
        measuredDataList = [[Double](), [Double](), [Double]()]
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true
        ) { [weak self] timer in
            second += 1
            
            if second == 600 {
                timer.invalidate()
            }
            
            if let data = self?.manager.accelerometerData {
                self?.measuredDataList[0].append(data.acceleration.x)
                self?.measuredDataList[1].append(data.acceleration.y)
                self?.measuredDataList[2].append(data.acceleration.z)
            }
        }
    }
    
    func measureGyro() {
        manager.startGyroUpdates()
        manager.gyroUpdateInterval = 0.1
        
        var second = 0

        measuredDataList = [[Double](), [Double](), [Double]()]
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.1, repeats: true
        ) { [weak self] timer in
            second += 1
            
            if second == 600 {
                timer.invalidate()
            }

            if let data = self?.manager.gyroData {
                self?.measuredDataList[0].append(data.rotationRate.x)
                self?.measuredDataList[1].append(data.rotationRate.y)
                self?.measuredDataList[2].append(data.rotationRate.z)
            }
        }
    }
    
    func stopMeasurement() {
        timer.invalidate()
    }

    func getMeasurementResult() -> [[Double]] {
        let result = measuredDataList
        measuredDataList = [[Double]]()
        return result
    }
}
