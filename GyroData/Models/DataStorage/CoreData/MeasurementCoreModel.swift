//
//  MeasurementCoreModel+CoreDataClass.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/02/01.
//
//

import Foundation
import CoreData

@objc(MeasurementCoreModel)
public class MeasurementCoreModel: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeasurementCoreModel> {
        return NSFetchRequest<MeasurementCoreModel>(entityName: "MeasurementCoreModel")
    }

    @NSManaged public var axisValues: String
    @NSManaged public var date: Date
    @NSManaged public var sensor: Int16
    @NSManaged public var time: Double
}
