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

    @NSManaged public var startDate: Date?
    @NSManaged public var msInterval: Int64
    @NSManaged public var coordinate: NSObject?

}

extension MotionRecordEntity : Identifiable {

}
