//
//  Velocity+CoreDataProperties.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    
//

import Foundation
import CoreData


extension Velocity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Velocity> {
        return NSFetchRequest<Velocity>(entityName: "Velocity")
    }

    @NSManaged public var x: Int16
    @NSManaged public var y: Int16
    @NSManaged public var z: Int16
    @NSManaged public var gyro: NSOrderedSet?

}

// MARK: Generated accessors for gyro
extension Velocity {

    @objc(insertObject:inGyroAtIndex:)
    @NSManaged public func insertIntoGyro(_ value: Gyro, at idx: Int)

    @objc(removeObjectFromGyroAtIndex:)
    @NSManaged public func removeFromGyro(at idx: Int)

    @objc(insertGyro:atIndexes:)
    @NSManaged public func insertIntoGyro(_ values: [Gyro], at indexes: NSIndexSet)

    @objc(removeGyroAtIndexes:)
    @NSManaged public func removeFromGyro(at indexes: NSIndexSet)

    @objc(replaceObjectInGyroAtIndex:withObject:)
    @NSManaged public func replaceGyro(at idx: Int, with value: Gyro)

    @objc(replaceGyroAtIndexes:withGyro:)
    @NSManaged public func replaceGyro(at indexes: NSIndexSet, with values: [Gyro])

    @objc(addGyroObject:)
    @NSManaged public func addToGyro(_ value: Gyro)

    @objc(removeGyroObject:)
    @NSManaged public func removeFromGyro(_ value: Gyro)

    @objc(addGyro:)
    @NSManaged public func addToGyro(_ values: NSOrderedSet)

    @objc(removeGyro:)
    @NSManaged public func removeFromGyro(_ values: NSOrderedSet)

}

extension Velocity : Identifiable {

}
