//
//  ModelEntity+CoreDataProperties.swift
//  GyroData
//
//  Created by Tak on 2022/12/26.
//
//

import Foundation
import CoreData

extension ModelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ModelEntity> {
        return NSFetchRequest<ModelEntity>(entityName: "ModelEntity")
    }

    @NSManaged public var sensorType: String?
    @NSManaged public var figure: String?
    @NSManaged public var date: String?

}

extension ModelEntity : Identifiable {

}
