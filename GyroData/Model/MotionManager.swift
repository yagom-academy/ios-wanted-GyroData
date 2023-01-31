//
//  File.swift
//  GyroData
//
//  Created by leewonseok on 2023/01/31.
//

import Foundation
import CoreMotion

class MotionManager {
    var manager = CMMotionManager()
    
    var interval: Double = 0.0
    
    func configureInterval() {
        interval = 0.1
    }
    func acclerometerMode() {
        manager.accelerometerUpdateInterval = interval
        manager.startAccelerometerUpdates(to: OperationQueue()) { (data ,error) in
            guard let data else { return }
            print("\(data.acceleration.x)")
            print("\(data.acceleration.y)")
            print("\(data.acceleration.z)")
        }
    }
    
    func start(type: MotionType) {
        switch type {
        case .acc:
            acclerometerMode()
        case .gyro:
            gyroMode()
        }
    }
    
    func stop() {
        manager.stopGyroUpdates()
        manager.stopAccelerometerUpdates()
    }
    
    func gyroMode() {
        manager.gyroUpdateInterval = interval
        manager.startGyroUpdates(to: OperationQueue()) { (data, error) in
            guard let data else { return }
            print("\(data.rotationRate.x)")
            print("\(data.rotationRate.y)")
            print("\(data.rotationRate.z)")
        }
    }
}
