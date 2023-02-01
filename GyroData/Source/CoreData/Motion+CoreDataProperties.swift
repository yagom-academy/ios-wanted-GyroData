//
//  Motion+CoreDataProperties.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/02/01.
//
//

import Foundation
import CoreData


extension Motion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Motion> {
        return NSFetchRequest<Motion>(entityName: "Motion")
    }

    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var runningTime: Double
    @NSManaged public var jsonData: String?
    @NSManaged public var id: UUID?

}

extension Motion : Identifiable {

}
