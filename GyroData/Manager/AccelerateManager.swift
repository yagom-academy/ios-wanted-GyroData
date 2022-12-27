//
//  AccelerateManager.swift
//  GyroData
//
//  Created by Ellen J on 2022/12/27.
//

import Foundation
import CoreMotion

struct AccelerateManager: AnalysisManagerType {
    private let motion = CMMotionManager()
    
    func startAnalyse() -> AnalysisData {
        guard motion.isAccelerometerAvailable else {
            return (x: 0, y: 0, z: 0)
        }
        motion.accelerometerUpdateInterval = 0.1
        motion.startAccelerometerUpdates()
        
        guard let data = self.motion.accelerometerData?.acceleration else {
            return (x: 0, y: 0, z: 0)
        }
        return (x: data.x, y: data.y, z: data.z)
    }
    
    func stopAnalyse() {
        motion.stopAccelerometerUpdates()
    }
}
