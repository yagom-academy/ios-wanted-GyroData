//
//  CoreMotionService.swift
//  GyroData
//
//  Created by 신병기 on 2022/09/25.
//

import Foundation
import CoreMotion

class CoreMotionService {
    private let motionManager = CMMotionManager()
    private let motionInterval = 6 / 60.0
    private var timer: Timer?
    
    private var completion: (() -> Void)? = nil
    private var resultCompletion: ((MotionDetailData) -> Void)? = nil
    
    // MARK: - startMotion
    func startMeasurement(of type: MotionType, completion: @escaping () -> Void, resultCompletion: @escaping (MotionDetailData) -> Void) {
        self.completion = completion
        self.resultCompletion = resultCompletion
        completion()
        
        switch type {
        case .acc:  startAccelerometers()
        case .gyro: startGyros()
        }
    }
    
    private func startAccelerometers() {
        if self.motionManager.isAccelerometerAvailable {
            self.motionManager.accelerometerUpdateInterval = self.motionInterval
            self.motionManager.startAccelerometerUpdates()
            
            var timeout = 10 // TODO: 600
            
            self.timer = Timer(fire: Date(), interval: 0.1, repeats: true, block: { timer in
                guard timeout > 0 else {
                    self.stopMeasurement(of: .acc)
                    return
                }
                timeout -= 1
                
                if let data = self.motionManager.accelerometerData {
                    let x = data.acceleration.x
                    let y = data.acceleration.y
                    let z = data.acceleration.z
                    
                    self.resultCompletion?(MotionDetailData(date: Date(), x: x, y: y, z: z))
                }
                print(#function, timeout)
            })
            
            if let timer = self.timer {
                RunLoop.current.add(timer, forMode: .default)
            }
        }
    }
    
    private func startGyros() {
        if self.motionManager.isGyroAvailable {
            self.motionManager.gyroUpdateInterval = self.motionInterval
            self.motionManager.startGyroUpdates()
            
            var timeout = 10
            
            self.timer = Timer(fire: Date(), interval: 0.1, repeats: true, block: { timer in
                guard timeout > 0 else {
                    self.stopMeasurement(of: .gyro)
                    return
                }
                timeout -= 1
                
                if let data = self.motionManager.gyroData {
                    let x = data.rotationRate.x
                    let y = data.rotationRate.y
                    let z = data.rotationRate.z
                    
                    self.resultCompletion?(MotionDetailData(date: Date(), x: x, y: y, z: z))
                }
                print(#function, timeout)
            })
            
            if let timer = self.timer {
                RunLoop.current.add(timer, forMode: .default)
            }
            
        }
    }
    
    func stopMeasurement(of type: MotionType) {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
            
            switch type {
            case .acc:  self.motionManager.stopAccelerometerUpdates()
            case .gyro: self.motionManager.stopGyroUpdates()
            }
        }
        self.completion?()
    }
    
}
