//
//  MotionEntity+CoreDataProperties.swift
//  GyroData
//
//  Created by Baek on 2022/12/27.
//
//

import Foundation
import CoreData


extension MotionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionEntity> {
        return NSFetchRequest<MotionEntity>(entityName: "MotionEntity")
    }

    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var z: Double
    @NSManaged public var createdAt: Double
    @NSManaged public var id: UUID
    @NSManaged public var motionType: String

}

extension MotionEntity : Identifiable {

}
