//
//  SensorMeasureService.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/01.
//

import CoreMotion
import Foundation

final class SensorMeasureService {
    typealias Values = (x: Double, y: Double, z: Double)
    
    private var data: Values = (0, 0, 0) {
        didSet {
            delegate?.updateData(data)
        }
    }
    
    private weak var delegate: MeasureServiceDelegate?
    private var timer: Timer = .init()
    private let motionManager: CMMotionManager
    
    init(delegate: MeasureServiceDelegate) {
        self.delegate = delegate
        self.motionManager = .init()
    }
    
    func measureStart(_ sensorType: Sensor, interval: TimeInterval, duration: TimeInterval) {
        switch sensorType {
        case .accelerometer:
            accelerometerMeasureStart(interval, duration)
        case .gyroscope:
            gyroscopeMeasureStart(interval, duration)
        }
    }
    
    func measureStop() {
        timer.invalidate()
        delegate?.endMeasuringData()
    }
}

private extension SensorMeasureService {
    func accelerometerMeasureStart(_ interval: TimeInterval, _ duration: TimeInterval) {
        guard motionManager.isAccelerometerAvailable else {
            delegate?.nonAccelerometerMeasurable()
            return
        }
        let fireDate = Date()
        
        motionManager.accelerometerUpdateInterval = interval
        motionManager.startAccelerometerUpdates()
        
        timer = Timer(timeInterval: interval, repeats: true) { timer in
            if let data = self.motionManager.accelerometerData {
                let accelerationData = (x: data.acceleration.x, y: data.acceleration.y, z: data.acceleration.z)
                self.data = accelerationData
            }
            
            if self.isTimeOver(duration, from: fireDate) {
                self.timer.invalidate()
            }
        }
        
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func isTimeOver(_ duration: TimeInterval, from fireDate: Date) -> Bool {
        let wasteTime = Date().timeIntervalSince(fireDate)

        if wasteTime > duration {
            delegate?.emitWasteTime(wasteTime)
            return true
        } else {
            return false
        }
    }
    
    func gyroscopeMeasureStart(_ interval: TimeInterval, _ duration: TimeInterval) {
        guard motionManager.isGyroAvailable else {
            delegate?.nonGyroscopeMeasurable()
            return
        }
        
        motionManager.gyroUpdateInterval = interval
        motionManager.startGyroUpdates()
        
        timer = Timer(timeInterval: interval, repeats: true) { timer in
            if let data = self.motionManager.gyroData {
                let gyroData = (data.rotationRate.x, data.rotationRate.y, data.rotationRate.z)
                self.data = gyroData
            }
            
            if self.isTimeOver(duration, from: timer.fireDate) {
                timer.invalidate()
            }
        }
        
        RunLoop.current.add(timer, forMode: .common)
    }
}
