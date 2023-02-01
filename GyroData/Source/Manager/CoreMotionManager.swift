//  GyroData - CoreMotionManager.swift
//  Created by zhilly, woong on 2023/02/01

import Foundation
import CoreMotion

final class CoreMotionManager {
    private var motion = CMMotionManager()
    private var timer: Timer?
    
    func startGyros(completion: @escaping (MeasureData) -> Void) {
        if motion.isGyroAvailable {
            self.motion.gyroUpdateInterval = 1.0 / 60.0
            self.motion.startGyroUpdates()
            
            self.timer = Timer(fire: Date(),
                               interval: (10.0 / 60.0),
                               repeats: true,
                               block: { (timer) in
                
                if let data = self.motion.gyroData {
                    let x = data.rotationRate.x
                    let y = data.rotationRate.y
                    let z = data.rotationRate.z
                    completion(.init(x: x, y: y, z: z))
                }
            })
            
            RunLoop.current.add(self.timer ?? Timer(), forMode: .default)
        }
    }
    
    func stopGyros() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
            
            self.motion.stopGyroUpdates()
        }
    }
    
    func startAccelerometers(completion: @escaping (MeasureData) -> Void) {
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0
            self.motion.startAccelerometerUpdates()
            
            self.timer = Timer(fire: Date(),
                               interval: (10.0 / 60.0),
                               repeats: true,
                               block: { (timer) in
                if let data = self.motion.accelerometerData {
                    let x = data.acceleration.x
                    let y = data.acceleration.y
                    let z = data.acceleration.z
                    
                    completion(.init(x: x, y: y, z: z))
                }
            })
            
            RunLoop.current.add(self.timer ?? Timer(), forMode: .default)
        }
    }
}
