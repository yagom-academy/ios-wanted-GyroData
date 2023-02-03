//
//  MotionData+CoreDataProperties.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    
//

import Foundation
import CoreData


extension MotionData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionData> {
        return NSFetchRequest<MotionData>(entityName: "MotionData")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var accelerometer: Acceletometer?
    @NSManaged public var gyro: Gyro?

}

extension MotionData : Identifiable {

}
