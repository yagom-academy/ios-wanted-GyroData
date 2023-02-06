//
//  Acceleration+CoreDataProperties.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    
//

import Foundation
import CoreData


extension Acceleration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Acceleration> {
        return NSFetchRequest<Acceleration>(entityName: "Acceleration")
    }

    @NSManaged public var x: Int16
    @NSManaged public var y: Int16
    @NSManaged public var z: Int16
    @NSManaged public var accelerometer: NSOrderedSet?

}

// MARK: Generated accessors for accelerometer
extension Acceleration {

    @objc(insertObject:inAccelerometerAtIndex:)
    @NSManaged public func insertIntoAccelerometer(_ value: Acceletometer, at idx: Int)

    @objc(removeObjectFromAccelerometerAtIndex:)
    @NSManaged public func removeFromAccelerometer(at idx: Int)

    @objc(insertAccelerometer:atIndexes:)
    @NSManaged public func insertIntoAccelerometer(_ values: [Acceletometer], at indexes: NSIndexSet)

    @objc(removeAccelerometerAtIndexes:)
    @NSManaged public func removeFromAccelerometer(at indexes: NSIndexSet)

    @objc(replaceObjectInAccelerometerAtIndex:withObject:)
    @NSManaged public func replaceAccelerometer(at idx: Int, with value: Acceletometer)

    @objc(replaceAccelerometerAtIndexes:withAccelerometer:)
    @NSManaged public func replaceAccelerometer(at indexes: NSIndexSet, with values: [Acceletometer])

    @objc(addAccelerometerObject:)
    @NSManaged public func addToAccelerometer(_ value: Acceletometer)

    @objc(removeAccelerometerObject:)
    @NSManaged public func removeFromAccelerometer(_ value: Acceletometer)

    @objc(addAccelerometer:)
    @NSManaged public func addToAccelerometer(_ values: NSOrderedSet)

    @objc(removeAccelerometer:)
    @NSManaged public func removeFromAccelerometer(_ values: NSOrderedSet)

}

extension Acceleration : Identifiable {

}
