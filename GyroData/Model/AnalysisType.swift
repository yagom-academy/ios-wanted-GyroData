//
//  AnalysisType.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/26.

import Foundation

enum AnalysisType: String, Codable {
    case accelerate = "accelerate"
    case gyroscope = "gyroscope"
}

struct CellModel: Codable {
    let id: UUID
    let analysisType: String
    let savedAt: Date
    let measurementTime: Double
}

struct GraphModel: Codable {
    let x: Double
    let y: Double
    let z: Double
    let measurementTime: Double
}
