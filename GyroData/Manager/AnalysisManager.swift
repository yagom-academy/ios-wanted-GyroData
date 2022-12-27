//
//  AnalysisManager.swift
//  GyroData
//
//  Created by Ellen J on 2022/12/26.
//

import Foundation
import CoreMotion

enum Analysis: String {
    case accelerate = "accelerate"
    case gyroscope = "gyroscope"
    
    var manager: AnalysisManagerType {
        switch self {
        case .accelerate:
            return AccelerateManager()
        case .gyroscope:
            return GyroscopeManager()
        }
    }
}

protocol AnalysisManagerType {
    func startAnalyse() -> AnalysisType
    func stopAnalyse()
}

struct AnalysisManager {
    let manager: AnalysisManagerType
    
    init(analysis: Analysis) {
        self.manager = analysis.manager
    }
    
    func startAnalyse() -> AnalysisType {
        return manager.startAnalyse()
    }
    
    func stopAnalyse() {
        return manager.stopAnalyse()
    }
}
