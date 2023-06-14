//
//  GyroEntity+CoreDataProperties.swift
//  GyroData
//
//  Created by 리지 on 2023/06/13.
//
//

import Foundation
import CoreData


extension GyroEntity: EntityKeyProtocol {
    static let key = "GyroEntity"

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GyroEntity> {
        return NSFetchRequest<GyroEntity>(entityName: "GyroEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var recordURL: Data?
}

extension GyroEntity : Identifiable {

}
