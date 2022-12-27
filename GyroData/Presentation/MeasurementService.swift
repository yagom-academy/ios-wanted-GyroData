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

    func measureAccelerometer() {
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        
        var second = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            second += 1
            
            if second == 600 {
                timer.invalidate()
            }
            
            if let data = self.manager.accelerometerData {
                // TODO: 데이터 저장 코드 작성
                print(data.acceleration.x)
                print(data.acceleration.y)
                print(data.acceleration.z)
            }
        }
    }
    
    func measureGyro() {
        manager.startGyroUpdates()
        manager.gyroUpdateInterval = 0.1
        
        var second = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            second += 1
            
            if second == 600 {
                timer.invalidate()
            }
            
            if let data = self.manager.gyroData {
                // TODO: 데이터 저장 코드 작성
                print(data.rotationRate.x)
                print(data.rotationRate.y)
                print(data.rotationRate.z)
            }
        }
    }
    
    func stopMeasurement() {
        timer.invalidate()
    }
}
