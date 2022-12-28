//
//  GyroModel.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/27.
//

import Foundation

struct GyroModel {
    let id: UUID
    let x: Double
    let y: Double
    let z: Double
    let createdAt: Double
    let motionType: String
    
    init(id: UUID, x: Double, y: Double, z: Double, createdAt: Double, motionType: String) {
        self.id = id
        self.x = x
        self.y = y
        self.z = z
        self.createdAt = createdAt
        self.motionType = motionType
    }
}
