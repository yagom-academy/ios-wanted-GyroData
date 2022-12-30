//
//  AnalysisType.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/26.

import Foundation

struct CellModel: Codable {
    let id: UUID
    let analysisType: String
    let savedAt: Date
    let measurementTime: Double
}
