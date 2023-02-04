//
//  MotionManager.swift
//  GyroData
//
//  Created by stone, LJ on 2023/01/31.
//

import Foundation
import CoreMotion

final class MotionManager {
    private var manager = CMMotionManager()
    private var timer: Timer?
    var second: Double = 0.0
    
    private var interval: Double = 0.0
    
    func start(type: MotionType, completion: @escaping (Coordinate) -> Void) {
        second = 0
        switch type {
        case .acc:
            accelerometerMode(completion: completion)
        case .gyro:
            gyroMode(completion: completion)
        }
    }
    
    func configureTimeInterval(interval: Double) {
        self.interval = interval
    }
    
    func stop() {
        timer?.invalidate()
        manager.stopGyroUpdates()
        manager.stopAccelerometerUpdates()
    }
    
    private func accelerometerMode(completion: @escaping (Coordinate) -> Void) {
        manager.accelerometerUpdateInterval = interval
        manager.startAccelerometerUpdates()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _ in
            if floor(self.second) == 60.0 {
                self.stop()
            }
            self.second += 0.1
            guard let data = self.manager.accelerometerData else { return }
            completion(self.convert(measureData: data))
        })
    }
    
    private func gyroMode(completion: @escaping (Coordinate) -> Void) {
        manager.gyroUpdateInterval = interval
        manager.startGyroUpdates()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _ in
            if floor(self.second) == 60.0 {
                self.stop()
            }
            self.second += 0.1
            guard let data = self.manager.gyroData else { return }
            completion(self.convert(measureData: data))
        })
    }
    
    private func convert(measureData: MeasureData) -> Coordinate {
        var (x,y,z) = (0.0, 0.0, 0.0)
        
        if let data = measureData as? CMAccelerometerData {
            x = data.acceleration.x
            y = data.acceleration.y
            z = data.acceleration.z
        } else if let data = measureData as? CMGyroData {
            x = data.rotationRate.x
            y = data.rotationRate.y
            z = data.rotationRate.z
        }
        
        return Coordinate(x: x.decimalPlace(3), y: y.decimalPlace(3), z: z.decimalPlace(3))
    }
    
}
