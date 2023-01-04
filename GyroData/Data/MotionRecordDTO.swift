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
    let motionMode: String
    let coordinates: [CoordinateDTO]
}

extension MotionRecordDTO {
    func toDomain() -> MotionRecord {
        return MotionRecord(
            id: id,
            startDate: startDate,
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
        motionRecordEntity.motionMode = motionMode
        motionRecordEntity.coordinates = coordinates.map {
            return [$0.x, $0.y, $0.z]
        }
        return motionRecordEntity
    }
}

extension MotionRecord {
    func toDTO() -> MotionRecordDTO {
        return MotionRecordDTO(
            id: id,
            startDate: startDate,
            motionMode: motionMode == .accelerometer ? "acc" : "gyro" ,
            coordinates: coordinates.map { return CoordinateDTO(x: $0.x, y: $0.y, z: $0.z) })
    }
}
