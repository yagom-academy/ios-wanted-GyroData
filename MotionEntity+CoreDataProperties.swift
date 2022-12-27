//
//  MotionEntity+CoreDataProperties.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/27.
//
//

import Foundation
import CoreData


extension MotionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionEntity> {
        return NSFetchRequest<MotionEntity>(entityName: "MotionEntity")
    }

    @NSManaged public var date: String?
    @NSManaged public var measurementType: String?
    @NSManaged public var coordinate: Coordinate?

}

extension MotionEntity : Identifiable {

}
