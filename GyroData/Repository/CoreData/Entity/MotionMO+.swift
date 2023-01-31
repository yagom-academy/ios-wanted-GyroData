//
//  MotionMO+.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

extension MotionMO: DomainConvertible {
    func asDomain() -> Motion? {
        guard let type = Motion.MeasurementType.init(rawValue: Int(self.type)) else { return nil }
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
