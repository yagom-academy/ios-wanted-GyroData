//
//  MotionDataEntity+CoreDataProperties.swift
//  GyroData
//
//  Created by junho on 2023/01/31.
//
//

import Foundation
import CoreData


extension MotionDataEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionDataEntity> {
        return NSFetchRequest<MotionDataEntity>(entityName: "MotionDataEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var createdAt: Date
    @NSManaged public var length: Double
    @NSManaged public var motionDataType: String

}

extension MotionDataEntity : Identifiable {
}
