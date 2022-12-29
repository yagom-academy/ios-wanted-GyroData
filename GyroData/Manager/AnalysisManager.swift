//
//  AnalysisManager.swift
//  GyroData
//
//  Created by Ellen J on 2022/12/26.
//

import Foundation
import CoreMotion

typealias AnalysisData = (x: Double, y: Double, z: Double)

protocol AnalysisManagerType {
    func startAnalyse() -> AnalysisData
    func stopAnalyse()
}

struct AnalysisManager: AnalysisManagerType {
    let manager: AnalysisManagerType
    
    init(analysis: AnalysisType) {
        switch analysis {
        case .accelerate:
            manager = AccelerateManager()
        case .gyroscope:
            manager = GyroscopeManager()
        }
    }
    
    func startAnalyse() -> AnalysisData {
        return manager.startAnalyse()
    }
    
    func stopAnalyse() {
        return manager.stopAnalyse()
    }
}
