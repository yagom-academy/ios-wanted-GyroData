//
//  MotionEntity+CoreDataProperties.swift
//  GyroData
//
//  Created by stone, LJ on 2023/02/01.
//
//

import Foundation
import CoreData


extension MotionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionEntity> {
        return NSFetchRequest<MotionEntity>(entityName: "MotionEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var time: Double
    @NSManaged public var date: Date?
    @NSManaged public var measureType: String?

}

extension MotionEntity : Identifiable {

}
