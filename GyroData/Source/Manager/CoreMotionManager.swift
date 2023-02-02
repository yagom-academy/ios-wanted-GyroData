//  GyroData - CoreMotionManager.swift
//  Created by zhilly, woong on 2023/02/01

import Foundation
import CoreMotion

final class CoreMotionManager {
    private var motion = CMMotionManager()
    private var timer: Timer?
    var second: Double = 0
    
    private var xData: [Double] = []
    private var yData: [Double] = []
    private var zData: [Double] = []
    
    func startGyros(completion: @escaping (SensorData) -> Void) {
        if motion.isGyroAvailable {
            self.motion.gyroUpdateInterval = 1.0 / 60.0
            self.motion.startGyroUpdates()
            
            self.timer = Timer(fire: Date(),
                               interval: (10.0 / 60.0),
                               repeats: true,
                               block: { (timer) in
                
                self.second += 0.1

                if self.second >= 60.0 {
                    NotificationCenter.default.post(name: .timeOver, object: nil)
                    self.stopGyros()
                }
                
                if let data = self.motion.gyroData {
                    self.xData.append(data.rotationRate.x)
                    self.yData.append(data.rotationRate.y)
                    self.zData.append(data.rotationRate.z)

                    completion(.init(x: self.xData, y: self.yData, z: self.zData))
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
    
    func startAccelerometers(completion: @escaping (SensorData) -> Void) {
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0
            self.motion.startAccelerometerUpdates()
            
            self.timer = Timer(fire: Date(),
                               interval: (10.0 / 60.0),
                               repeats: true,
                               block: { (timer) in
 
                self.second += 0.1

                if self.second >= 60.0 {
                    NotificationCenter.default.post(name: .timeOver, object: nil)
                    self.stopAccelerometers()
                }
                
                if let data = self.motion.accelerometerData {
                    self.xData.append(data.acceleration.x)
                    self.yData.append(data.acceleration.y)
                    self.zData.append(data.acceleration.z)

                    completion(.init(x: self.xData, y: self.yData, z: self.zData))
                }
            })
            
            RunLoop.current.add(self.timer ?? Timer(), forMode: .default)
        }
    }
    
    func stopAccelerometers() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
            
            self.motion.stopAccelerometerUpdates()
        }
    }
}
