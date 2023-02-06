//
//  MotionDTO.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

struct MotionDTO: Codable, Identifiable {
    let id: String
    let date: Double
    let type: Int
    let time: Double
    let x: [Double]
    let y: [Double]
    let z: [Double]
}

extension MotionDTO: DomainConvertible {
    func asDomain() -> Motion? {
        guard let type = Motion.MeasurementType.init(rawValue: self.type) else { return nil }
        return Motion(
            id: self.id,
            date: Date(timeIntervalSince1970: self.date),
            type: type,
            time: self.time,
            data: Motion.MeasurementData(
                x: self.x,
                y: self.y,
                z: self.z
            )
        )
    }
}

extension MotionDTO {
    init(from motion: Motion) {
        self.id = motion.id
        self.date = motion.date.timeIntervalSince1970
        self.type = motion.type.rawValue
        self.time = motion.time
        self.x = motion.data.x
        self.y = motion.data.y
        self.z = motion.data.z
    }
}
