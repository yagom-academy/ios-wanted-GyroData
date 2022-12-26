//
//  CoreDataManaged.swift
//  GyroData
//
//  Created by 오경식 on 2022/12/26.
//

import Foundation
import CoreData

class GyroData: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<GyroData> {
        return NSFetchRequest<GyroData>(entityName: "GyroData")
    }
}
