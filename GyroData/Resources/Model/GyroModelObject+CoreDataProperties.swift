//
//  GyroModelObject+CoreDataProperties.swift
//  GyroData
//
//  Created by Mangdi on 2023/01/31.
//
//

import Foundation
import CoreData


extension GyroModelObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GyroModelObject> {
        return NSFetchRequest<GyroModelObject>(entityName: "GyroModelObject")
    }

    @NSManaged public var saveDate: String
    @NSManaged public var sensorType: String
    @NSManaged public var recordTime: Double
    @NSManaged public var jsonName: String
    @NSManaged public var id: UUID

}

extension GyroModelObject : Identifiable {

}
