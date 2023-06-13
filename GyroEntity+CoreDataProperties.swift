//
//  GyroEntity+CoreDataProperties.swift
//  GyroData
//
//  Created by 리지 on 2023/06/13.
//
//

import Foundation
import CoreData


extension GyroEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GyroEntity> {
        return NSFetchRequest<GyroEntity>(entityName: "GyroEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Double
    @NSManaged public var title: String?
    @NSManaged public var record: NSObject?

}

extension GyroEntity : Identifiable {

}
