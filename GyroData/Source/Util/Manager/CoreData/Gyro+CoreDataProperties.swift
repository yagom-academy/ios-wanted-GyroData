//
//  Gyro+CoreDataProperties.swift
//  GyroData
//
//  Created by dhoney96 on 2022/12/26.
//
//

import CoreData


extension Gyro {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gyro> {
        return NSFetchRequest<Gyro>(entityName: "Gyro")
    }

    @NSManaged public var measurementTime: Date?
    @NSManaged public var measurementDate: String?
    @NSManaged public var sensorType: String?

}

extension Gyro : Identifiable {

}
