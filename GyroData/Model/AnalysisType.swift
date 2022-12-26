//
//  AnalysisType.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/26.
//

import Foundation

protocol AnalysisType: Codable {
    var x: Double { get }
    var y: Double { get }
    var z: Double { get }
    var measurementTime: Date { get }
    var savedAt: Date { get }
}

struct Model {}

