//
//  CoordinateEntity+CoreDataProperties.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/28.
//
//

import Foundation
import CoreData


extension CoordinateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoordinateEntity> {
        return NSFetchRequest<CoordinateEntity>(entityName: "CoordinateEntity")
    }

    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var z: Double

}

extension CoordinateEntity : Identifiable {

}
