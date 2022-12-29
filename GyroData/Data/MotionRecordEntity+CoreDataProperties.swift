//
//  MotionRecordEntity+CoreDataProperties.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/28.
//
//

import Foundation
import CoreData


extension MotionRecordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionRecordEntity> {
        return NSFetchRequest<MotionRecordEntity>(entityName: "MotionRecordEntity")
    }

    @NSManaged public var motionRecordId: UUID
    @NSManaged public var startDate: Date
    @NSManaged public var msInterval: Int64
    @NSManaged public var motionMode: String
    @NSManaged public var coordinates: [[Double]]

    func toDomain() -> MotionRecord {
        return MotionRecord(
            id: motionRecordId,
            startDate: startDate,
            msInterval: Int(msInterval),
            motionMode: .accelerometer,
            coordinates: coordinates.map { Coordinate(x: $0[0], y: $0[1], z: $0[2]) }
        )
    }
}

extension MotionRecordEntity : Identifiable {

}
