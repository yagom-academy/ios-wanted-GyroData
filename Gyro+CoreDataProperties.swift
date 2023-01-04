//
//  Gyro+CoreDataProperties.swift
//  GyroData
//
//  Created by dhoney96 on 2022/12/29.
//
//

import Foundation
import CoreData


extension Gyro {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gyro> {
        return NSFetchRequest<Gyro>(entityName: "Gyro")
    }

    @NSManaged public var measurementDate: String?
    @NSManaged public var measurementTime: Double
    @NSManaged public var sensorType: String?

}

extension Gyro : Identifiable {

}
