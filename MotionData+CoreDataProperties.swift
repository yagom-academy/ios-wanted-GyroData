//
//  MotionData+CoreDataProperties.swift
//  GyroData
//
//  Created by Subin Kim on 2022/09/21.
//
//

import Foundation
import CoreData


extension MotionData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionData> {
        return NSFetchRequest<MotionData>(entityName: "MotionData")
    }

    @NSManaged public var date: String
    @NSManaged public var dataType: String
    @NSManaged public var measureTime: String
    @NSManaged public var motionX: [Double]
    @NSManaged public var motionY: [Double]
    @NSManaged public var motionZ: [Double]

}

extension MotionData : Identifiable {

}
