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
    
    private var timer: Timer = .init()
    private let motionManager: CMMotionManager = .init()
    private var fireDate: Date = Date()
    weak var delegate: MeasureServiceDelegate?
    
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
        let wasteTime = fireDate.timeIntervalSince(Date())
        delegate?.endMeasuringData(wasteTime)
    }
}

private extension SensorMeasureService {
    func accelerometerMeasureStart(_ interval: TimeInterval, _ duration: TimeInterval) {
        guard motionManager.isAccelerometerAvailable else {
            delegate?.nonAccelerometerMeasurable()
            return
        }
        
        motionManager.accelerometerUpdateInterval = interval
        motionManager.startAccelerometerUpdates()
        fireDate = Date()
            
        timer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let data = self.motionManager.accelerometerData {
                let accelerationData = (x: data.acceleration.x, y: data.acceleration.y, z: data.acceleration.z)
                self.data = accelerationData
            }
            
            if self.isTimeOver(duration, from: self.fireDate) {
                self.measureStop()
                self.motionManager.stopAccelerometerUpdates()
            }
        }
        
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func isTimeOver(_ duration: TimeInterval, from fireDate: Date) -> Bool {
        fireDate.timeIntervalSince(fireDate) > duration ? true : false
    }
    
    func gyroscopeMeasureStart(_ interval: TimeInterval, _ duration: TimeInterval) {
        guard motionManager.isGyroAvailable else {
            delegate?.nonGyroscopeMeasurable()
            return
        }
        
        motionManager.gyroUpdateInterval = interval
        motionManager.startGyroUpdates()
        fireDate = Date()
        
        timer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let data = self.motionManager.gyroData {
                let gyroData = (data.rotationRate.x, data.rotationRate.y, data.rotationRate.z)
                self.data = gyroData
            }
            
            if self.isTimeOver(duration, from: self.fireDate) {
                self.measureStop()
                self.motionManager.stopGyroUpdates()
            }
        }
        
        RunLoop.current.add(timer, forMode: .common)
    }
}
