//
//  MotionManager.swift
//  GyroData
//
//  Created by junho, summercat on 2023/01/31.
//

import Foundation
import CoreMotion

final class MotionManager: MotionManagerType {
    enum Constant {
        enum Namespace {
            static let updateInterval: Double = 1.0 / 10.0
            static let maxLength: Double = 60.0
        }
    }
    
    private let motion: CMMotionManager = CMMotionManager()
    private var timer: Timer = Timer()
    
    func startAccelerometer(_ handler: @escaping (Coordinate) -> Void) {
        guard motion.isAccelerometerAvailable else { return }
        motion.showsDeviceMovementDisplay = true
        motion.accelerometerUpdateInterval = Constant.Namespace.updateInterval
        motion.startAccelerometerUpdates()
        
        let startTime = Date()
        
        timer = Timer(
            fire: Date(),
            interval: Constant.Namespace.updateInterval,
            repeats: true
        ) { _ in
            let timeInterval = Date().timeIntervalSince(startTime)
            guard timeInterval <= Constant.Namespace.maxLength else {
                self.stopAccelerometer()
                return
            }
            if let data = self.motion.accelerometerData {
                let coordinate = Coordinate(data.acceleration)
                handler(coordinate)
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            let runLoop = RunLoop.current
            runLoop.add(self.timer, forMode: .default)
            runLoop.run()
        }
    }
    
    func stopAccelerometer() {
        timer.invalidate()
        motion.stopAccelerometerUpdates()
    }
    
    func startGyro(_ handler: @escaping (Coordinate) -> Void) {
        guard motion.isGyroAvailable else { return }
        motion.showsDeviceMovementDisplay = true
        motion.gyroUpdateInterval = Constant.Namespace.updateInterval
        motion.startGyroUpdates()
        
        let startTime = Date()
        
        timer = Timer(
            fire: Date(),
            interval: Constant.Namespace.updateInterval,
            repeats: true
        ) { _ in
            let timeInterval = Date().timeIntervalSince(startTime)
            guard timeInterval <= Constant.Namespace.maxLength else {
                self.stopAccelerometer()
                return
            }
            if let data = self.motion.gyroData {
                let coordinate = Coordinate(data.rotationRate)
                handler(coordinate)
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            let runLoop = RunLoop.current
            runLoop.add(self.timer, forMode: .default)
            runLoop.run()
        }
    }
    
    func stopGyro() {
        timer.invalidate()
        motion.stopGyroUpdates()
    }
}
