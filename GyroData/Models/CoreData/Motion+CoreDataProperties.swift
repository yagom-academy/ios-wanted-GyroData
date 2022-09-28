//
//  Motion+CoreDataProperties.swift
//  GyroData
//
//  Created by channy on 2022/09/21.
//
//

import Foundation
import CoreData


extension Motion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Motion> {
        return NSFetchRequest<Motion>(entityName: "Motion")
    }

    @NSManaged public var date: Date?
    @NSManaged public var path: String?
    @NSManaged public var time: Float
    @NSManaged public var type: String?

}

extension Motion : Identifiable {

}
