//
//  Gyro+CoreDataProperties.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    
//

import Foundation
import CoreData


extension Gyro {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gyro> {
        return NSFetchRequest<Gyro>(entityName: "Gyro")
    }

    @NSManaged public var velocity: Velocity?
    @NSManaged public var motionData: MotionData?

}
