//
//  AnalysisManager.swift
//  GyroData
//
//  Created by Ellen J, unchain, yeton on 2022/12/26.
//

import Foundation
import CoreMotion

typealias AnalysisData = (x: Double, y: Double, z: Double)

protocol AnalysisManagerType {
    func startAnalyze(mode: AnalysisType) -> AnalysisData
    func stopAnalyze(mode: AnalysisType)
}

struct AnalysisManager: AnalysisManagerType {
    private let motion = CMMotionManager()
    
    func startAnalyze(mode: AnalysisType) -> AnalysisData {
        switch mode {
        case .accelerate:
            return analyzeAccelerate()
        case .gyroscope:
            return analyzeGyroscope()
        }
    }
    
    func stopAnalyze(mode: AnalysisType) {
        switch mode {
        case .accelerate:
            return stopAnalyzeAccelerate()
        case .gyroscope:
            return stopAnalyzeGyroscope()
        }    }
    
    private func analyzeAccelerate() -> AnalysisData {
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
    
    private func analyzeGyroscope() -> AnalysisData {
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
    
    private func stopAnalyzeAccelerate() {
        motion.stopAccelerometerUpdates()
    }
    
    private func stopAnalyzeGyroscope() {
        motion.stopGyroUpdates()
    }
}
