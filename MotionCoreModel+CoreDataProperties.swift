//  GyroData - MotionCoreModel+CoreDataProperties.swift
//  Created by zhilly, woong on 2023/02/03

import Foundation
import CoreData

extension MotionCoreModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionCoreModel> {
        return NSFetchRequest<MotionCoreModel>(entityName: "MotionCoreModel")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var sensorType: String?
    @NSManaged public var xData: [Double]?
    @NSManaged public var yData: [Double]?
    @NSManaged public var zData: [Double]?
    @NSManaged public var runtime: Double
    
    var sensorMode: SensorMode {
        get {
            return SensorMode(rawValue: sensorType ?? .init()) ?? .Acc
        }
        set {
            sensorType = newValue.rawValue
        }
    }
}
