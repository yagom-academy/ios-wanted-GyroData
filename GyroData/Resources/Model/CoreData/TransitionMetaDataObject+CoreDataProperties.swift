//
//  TransitionMetaDataObject+CoreDataProperties.swift
//  GyroData
//
//  Created by Mangdi on 2023/01/31.
//
//

import Foundation
import CoreData


extension TransitionMetaDataObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransitionMetaDataObject> {
        return NSFetchRequest<TransitionMetaDataObject>(entityName: "TransitionMetaDataObject")
    }

    @NSManaged public var saveDate: String
    @NSManaged public var sensorType: String
    @NSManaged public var recordTime: Double
    @NSManaged public var jsonName: String
    @NSManaged public var id: UUID

}

extension TransitionMetaDataObject : Identifiable {

}
