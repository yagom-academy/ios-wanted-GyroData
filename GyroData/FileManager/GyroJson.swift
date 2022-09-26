//
//  GyroJson.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/26.
//

import Foundation

struct GyroJson: Codable {
    let coodinate: Coodinate
}

// MARK: - Coodinate
struct Coodinate: Codable {
    let x, y, z: Float
}
