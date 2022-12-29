//
//  MotionData+CoreDataProperties.swift
//  GyroDataTests
//
//  Created by 이원빈 on 2022/12/28.
//
//

import Foundation
import CoreData


extension MotionData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionData> {
        return NSFetchRequest<MotionData>(entityName: "MotionData")
    }

    @NSManaged public var date: Date
    @NSManaged public var uuid: UUID
    @NSManaged public var measuredTime: Double
    @NSManaged public var sensor: String

}

extension MotionData : Identifiable {

}
