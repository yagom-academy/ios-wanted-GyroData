//
//  Motion.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/27.
//

import Foundation

struct MotionInformation: Codable {
    let id: UUID
    let motionType: MotionType
    let date: Date
    let time: Double
    
    init(motionType: MotionType, date: Date, time: Double) {
        self.id = UUID()
        self.motionType = motionType
        self.date = date
        self.time = time
    }
    
    init(model: MotionInfo) {
        self.id = model.id ?? UUID()
        self.motionType = model.motion
        self.date = model.date ?? Date()
        self.time = model.time
    }
}
