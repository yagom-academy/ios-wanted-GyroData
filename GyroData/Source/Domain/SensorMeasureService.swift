//
//  SensorMeasureService.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/01.
//

import CoreMotion
import Foundation

protocol MeasureDelegate: AnyObject {
    typealias Values = (x: Double, y: Double, z: Double)
    
    func nonAccelerometerMeasurable()
    func nonGyroscopeMeasurable()
    
    func updateData(_ data: [Values])
}

final class SensorMeasureService {
    typealias Values = (x: Double, y: Double, z: Double)
    
    private var data: [Values] = [] {
        didSet {
            delegate?.updateData(data)
        }
    }
    
    private weak var delegate: MeasureDelegate?
    private var timer: Timer = .init()
    private let motionManager: CMMotionManager
    
    init(delegate: MeasureDelegate) {
        self.delegate = delegate
        self.motionManager = .init()
    }
    
    func measureStart(_ sensorType: Sensor, interval: TimeInterval, duration: TimeInterval) {
        data = .init()
        
        switch sensorType {
        case .accelerometer:
            accelerometerMeasureStart(interval, duration)
        case .gyroscope:
            gyroscopeMeasureStart(interval, duration)
        }
    }
    
    func measureStop() {
        timer.invalidate()
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
        
        timer = Timer(fire: Date(), interval: interval / duration, repeats: true) { timer in
            if let data = self.motionManager.accelerometerData {
                let accelerationData = (data.acceleration.x, data.acceleration.y, data.acceleration.z)
                
                self.data.append(accelerationData)
            }
        }
        
        RunLoop.current.add(timer, forMode: .common)
    }
    
    
    func gyroscopeMeasureStart(_ interval: TimeInterval, _ duration: TimeInterval) {
        motionManager.gyroUpdateInterval = interval
    }
}
