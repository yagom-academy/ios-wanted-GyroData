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
        
        motionManager.accelerometerUpdateInterval = 1.0 / 10.0
        motionManager.startAccelerometerUpdates()
        
        var timeCount = 0.0
        timer = Timer(fire: Date(), interval: 1.0 / 10.0, repeats: true, block: { (timer) in
            timeCount += 0.1
            if (round(timeCount * 10) / 10) == 60.0 {
                timer.invalidate()
            }
            
            if let data = self.motionManager.accelerometerData {
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
    
    func stopUpdates() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.stopAccelerometerUpdates()
        timer?.invalidate()
    }
}
