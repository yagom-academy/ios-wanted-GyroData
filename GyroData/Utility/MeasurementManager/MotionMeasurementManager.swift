//
//  MotionMeasurementManager.swift
//  GyroData
//
//  Created by Judy on 2022/12/28.
//

import CoreMotion

class MotionMeasurementManager {
    static let shared = MotionMeasurementManager()
    private let motionManager = CMMotionManager()
    private var timer: Timer?
    
    private init() {}
    
    func startAccelerometers(at graphView: GraphView) {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = MotionMeasurementNumber.updateInterval
        motionManager.startAccelerometerUpdates()
        
        var timeCount = Double.zero
        timer = Timer(fire: Date(),
                      interval: MotionMeasurementNumber.updateInterval,
                      repeats: true,
                      block: { [self] (timer) in
            
            timeCount += MotionMeasurementNumber.updateInterval
            
            if checkOutofTime(timeCount) {
                timer.invalidate()
            }
            
            if let data = motionManager.accelerometerData {
                let x = data.acceleration.x
                let y = data.acceleration.y
                let z = data.acceleration.z

                graphView.add([x, y, z])
            }
        })
        
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .default)
        }
    }
    
    func stopAccelerometer(at graphView: GraphView) {
        guard motionManager.isAccelerometerAvailable,
              let currentTimer = timer else { return }
        
        currentTimer.invalidate()
        timer = nil
        
        motionManager.stopAccelerometerUpdates()
        graphView.clearSegmanet()
    }
    
    func startGyros(at graphView: GraphView) {
        guard motionManager.isGyroAvailable else { return }

        motionManager.gyroUpdateInterval = MotionMeasurementNumber.updateInterval
        motionManager.startGyroUpdates()
        
        var timeCount = Double.zero
        
        timer = Timer(fire: Date(),
                      interval: MotionMeasurementNumber.updateInterval,
                      repeats: true,
                      block: { [self] (timer) in
            
            timeCount += MotionMeasurementNumber.updateInterval
            
            if checkOutofTime(timeCount) {
                timer.invalidate()
            }
            
            if let data = motionManager.gyroData {
                let x = data.rotationRate.x
                let y = data.rotationRate.y
                let z = data.rotationRate.z
                
                graphView.add([x, y, z])
            }
        })
        
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .default)
        }
        
    }
    
    func stopGyros(at graphView: GraphView) {
        guard motionManager.isGyroAvailable,
              let currentTimer = timer else { return }
        
        currentTimer.invalidate()
        timer = nil
        
        motionManager.stopGyroUpdates()
        graphView.clearSegmanet()
    }
    
    private func checkOutofTime(_ value: Double) -> Bool {
        return round(value * 10) / 10 == MotionMeasurementNumber.completeTime
    }
}

fileprivate enum MotionMeasurementNumber {
    static let updateInterval = 1.0 / 10.0
    static let completeTime = 60.0
}
