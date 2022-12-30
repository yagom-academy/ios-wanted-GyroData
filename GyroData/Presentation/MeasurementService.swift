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
    
    var gyroCoordinates: Observable<[(x: Double, y: Double, z: Double)]> = Observable([])

    private var stopAction: (() -> Void)?
    
    func measureAccelerometer() {
        gyroCoordinates.value = []
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        
        var second = 0
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true
        ) { [weak self] timer in
            second += 1
            
            if second == 600 {
                self?.stopAction?()
            }
            if let data = self?.manager.accelerometerData {
                self?.gyroCoordinates.value.append(
                    (x: data.acceleration.x,
                     y: data.acceleration.y,
                     z: data.acceleration.z)
                )
            }
        }
    }
    
    func measureGyro() {
        gyroCoordinates.value = []
        manager.startGyroUpdates()
        manager.gyroUpdateInterval = 0.1
        
        var second = 0

        timer = Timer.scheduledTimer(
            withTimeInterval: 0.1, repeats: true
        ) { [weak self] timer in
            second += 1
            
            if second == 600 {
                self?.stopAction?()
            }
            
            if let data = self?.manager.gyroData {
                self?.gyroCoordinates.value.append(
                    (x: data.rotationRate.x,
                     y: data.rotationRate.y,
                     z: data.rotationRate.z)
                )
            }
        }
    }
    
    func stopMeasurement() {
        timer.invalidate()
    }

    func getMeasurementResult() -> [(x: Double, y: Double, z: Double)] {
        let result = gyroCoordinates.value
        gyroCoordinates.value = []
        return result
    }
    
    func registStopAction(action: @escaping (() -> Void)) {
        stopAction = action
    }
}
