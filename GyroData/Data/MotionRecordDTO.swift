//
//  MotionRecordDTO.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/29.
//

import Foundation
import CoreData

struct MotionRecordDTO: Codable {
    let id: UUID
    let startDate: Date
    let msInterval: Int
    let motionMode: String
    let coordinates: [CoordinateDTO]
}

extension MotionRecordDTO {
    func toDomain() -> MotionRecord {
        return MotionRecord(
            id: id,
            startDate: startDate,
            msInterval: msInterval,
            motionMode: motionMode == "acc" ? .accelerometer : .gyroscope,
            coordinates: coordinates.map { Coordinate(x: $0.x, y: $0.y, z: $0.z) }
        )
    }
}

extension MotionRecordDTO {
    func toEntity(in context: NSManagedObjectContext) -> MotionRecordEntity {
        let motionRecordEntity = MotionRecordEntity(context: context)
        motionRecordEntity.motionRecordId = id
        motionRecordEntity.startDate = startDate
        motionRecordEntity.msInterval = Int64(msInterval)
        motionRecordEntity.motionMode = motionMode
        motionRecordEntity.coordinates = coordinates.map {
            return [$0.x, $0.y, $0.z]
        }
        return motionRecordEntity
    }
}
