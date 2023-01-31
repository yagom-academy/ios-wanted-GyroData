//
//  File.swift
//  GyroData
//
//  Created by stone, LJ on 2023/01/31.
//

import Foundation
import CoreMotion

class MotionManager {
    var manager = CMMotionManager()
    
    var interval: Double = 0.0
    
    func configureInterval() {
        interval = 0.1
    }
    
    func start(type: MotionType, completion: @escaping (MotionData) -> Void) {
        switch type {
        case .acc:
            acclerometerMode(completion: completion)
        case .gyro:
            gyroMode(completion: completion)
        }
    }
    
    func stop() {
        manager.stopGyroUpdates()
        manager.stopAccelerometerUpdates()
    }
    
    func acclerometerMode(completion: @escaping (MotionData) -> Void) {
        manager.accelerometerUpdateInterval = interval
        manager.startAccelerometerUpdates(to: OperationQueue()) { (data ,error) in
            guard let data else { return }
            completion(data)
        }
    }
    
    func gyroMode(completion: @escaping (MotionData) -> Void) {
        manager.gyroUpdateInterval = interval
        manager.startGyroUpdates(to: OperationQueue()) { (data, error) in
            guard let data else { return }
            completion(data)
        }
    }
}
