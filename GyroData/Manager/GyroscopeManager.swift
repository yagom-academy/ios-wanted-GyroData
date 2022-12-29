//
//  GyroscopeManager.swift
//  GyroData
//
//  Created by Ellen J on 2022/12/27.
//

import Foundation
import CoreMotion

struct GyroscopeManager: AnalysisManagerType {
    private let motion = CMMotionManager()
    
    func startAnalyse() -> AnalysisData {
        guard motion.isGyroAvailable else {
            return (x: 0, y: 0, z: 0)
        }
        
        motion.gyroUpdateInterval = 0.1
        motion.startGyroUpdates()
        
        guard let data = self.motion.gyroData?.rotationRate else {
            return (x: 0, y: 0, z: 0)
        }
            
        return (x: data.x, y: data.y, z: data.z)
    }
    
    func stopAnalyse() {
        self.motion.stopGyroUpdates()
    }
}
