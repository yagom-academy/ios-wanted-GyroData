//
//  Acceletometer+CoreDataProperties.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    
//

import Foundation
import CoreData


extension Acceletometer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Acceletometer> {
        return NSFetchRequest<Acceletometer>(entityName: "Acceletometer")
    }

    @NSManaged public var acceleration: Acceleration?
    @NSManaged public var motionData: NSOrderedSet?

}

// MARK: Generated accessors for motionData
extension Acceletometer {

    @objc(insertObject:inMotionDataAtIndex:)
    @NSManaged public func insertIntoMotionData(_ value: MotionData, at idx: Int)

    @objc(removeObjectFromMotionDataAtIndex:)
    @NSManaged public func removeFromMotionData(at idx: Int)

    @objc(insertMotionData:atIndexes:)
    @NSManaged public func insertIntoMotionData(_ values: [MotionData], at indexes: NSIndexSet)

    @objc(removeMotionDataAtIndexes:)
    @NSManaged public func removeFromMotionData(at indexes: NSIndexSet)

    @objc(replaceObjectInMotionDataAtIndex:withObject:)
    @NSManaged public func replaceMotionData(at idx: Int, with value: MotionData)

    @objc(replaceMotionDataAtIndexes:withMotionData:)
    @NSManaged public func replaceMotionData(at indexes: NSIndexSet, with values: [MotionData])

    @objc(addMotionDataObject:)
    @NSManaged public func addToMotionData(_ value: MotionData)

    @objc(removeMotionDataObject:)
    @NSManaged public func removeFromMotionData(_ value: MotionData)

    @objc(addMotionData:)
    @NSManaged public func addToMotionData(_ values: NSOrderedSet)

    @objc(removeMotionData:)
    @NSManaged public func removeFromMotionData(_ values: NSOrderedSet)

}
