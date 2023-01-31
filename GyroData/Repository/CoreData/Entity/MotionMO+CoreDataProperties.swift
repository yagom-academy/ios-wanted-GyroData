//
//  MotionMO+CoreDataProperties.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import CoreData

extension MotionMO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionMO> {
        return NSFetchRequest<MotionMO>(entityName: "MotionMO")
    }

    @NSManaged public var id: String
    @NSManaged public var date: Double
    @NSManaged public var type: Int16
    @NSManaged public var time: Double
    @NSManaged public var x: [Double]
    @NSManaged public var y: [Double]
    @NSManaged public var z: [Double]
}

extension MotionMO : Identifiable { }
