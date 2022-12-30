//
//  MotionEntity+CoreDataProperties.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/30.
//
//

import Foundation
import CoreData


extension MotionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionEntity> {
        return NSFetchRequest<MotionEntity>(entityName: "MotionEntity")
    }

    @NSManaged public var createdAt: Double
    @NSManaged public var id: UUID
    @NSManaged public var motionType: String
    @NSManaged public var coordinate: [[Double]]

}

extension MotionEntity : Identifiable {

}
