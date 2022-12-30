//
//  GyroModel.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/27.
//

import Foundation

public struct GyroModel {
    let id: UUID
    let coordinate: [[Double]]
    let createdAt: Double
    let motionType: String
    
    init(id: UUID, coordinate: [[Double]], createdAt: Double, motionType: String) {
        self.id = id
        self.coordinate = coordinate
        self.createdAt = createdAt
        self.motionType = motionType
    }
}
