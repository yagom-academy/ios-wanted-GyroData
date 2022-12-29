//
//  MeasurementService.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/27.
//

import CoreMotion

class MeasurementService {
    private let manager = CMMotionManager()
    private var timer = Timer()
    
    var accCoordinates: Observable<[(x: Double, y: Double, z: Double)]> = Observable([])
    var gyroCoordinates: Observable<[(x: Double, y: Double, z: Double)]> = Observable([])

    func measureAccelerometer() {
        accCoordinates.value = []
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        
        var second = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            second += 1
            
            if second == 600 {
                timer.invalidate()
            }
            if let data = self?.manager.accelerometerData {
                let coordinate = (data.acceleration.x, data.acceleration.y, data.acceleration.z)
                self?.accCoordinates.value.append(coordinate)
            }
        }
    }
    
    func measureGyro() {
        gyroCoordinates.value = []
        manager.startGyroUpdates()
        manager.gyroUpdateInterval = 0.1
        
        var second = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            second += 1
            
            if second == 600 {
                timer.invalidate()
            }
            
            if let data = self?.manager.gyroData {
                let coordinate = (data.rotationRate.x, data.rotationRate.y, data.rotationRate.z)
                self?.gyroCoordinates.value.append(coordinate)
            }
        }
    }
    
    func stopMeasurement() {
        timer.invalidate()
    }
}
