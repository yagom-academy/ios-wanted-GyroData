//
//  Gyroscope.swift
//  GyroData
//
//  Created by 오경식 on 2022/12/26.
//

import Foundation

struct Gyroscope: AnalysisType {
    let x: Double
    let y: Double
    let z: Double
    let measurementTime: Date
    let savedAt: Date
}

