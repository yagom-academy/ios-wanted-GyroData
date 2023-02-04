//
//  SensorData+CoreDataProperties.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/30.
//
//

import Foundation
import CoreData


extension SensorData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SensorData> {
        return NSFetchRequest<SensorData>(entityName: "SensorData")
    }

    @NSManaged public var xValue: [Double]
    @NSManaged public var yValue: [Double]
    @NSManaged public var zValue: [Double]
    @NSManaged public var type: Double
    @NSManaged public var runTime: Double
    @NSManaged public var date: Date

}

extension SensorData : Identifiable {

}
