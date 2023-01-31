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
    var timer: Timer?
    var second: Double = 0.0
    
    var interval: Double = 0.1
    
    func start(type: MotionType, completion: @escaping (MotionData) -> Void) {
        switch type {
        case .acc:
            accelerometerMode(completion: completion)
        case .gyro:
            gyroMode(completion: completion)
        }
    }
    
    func stop() {
        timer?.invalidate()
        manager.stopGyroUpdates()
        manager.stopAccelerometerUpdates()
    }
    
    func accelerometerMode(completion: @escaping (MotionData) -> Void) {
        manager.accelerometerUpdateInterval = interval
        manager.startAccelerometerUpdates()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _ in
            if floor(self.second) == 60.0 {
                self.stop()
            }
            self.second += 0.1
            guard let data = self.manager.accelerometerData else { return }
            completion(data)
        })
    }
    
    func gyroMode(completion: @escaping (MotionData) -> Void) {
        manager.gyroUpdateInterval = interval
        manager.startGyroUpdates()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _ in
            if floor(self.second) == 60.0 {
                self.stop()
            }
            self.second += 0.1
            guard let data = self.manager.gyroData else { return }
            completion(data)
        })
    }
}
