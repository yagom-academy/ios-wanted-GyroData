//
//  MotionDTO.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

struct MotionDTO: Codable, Identifiable {
    let id: String
    let date: Double
    let type: Int
    let time: Double
    let x: [Double]
    let y: [Double]
    let z: [Double]
}
