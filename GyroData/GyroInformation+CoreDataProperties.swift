//
//  GyroInformation+CoreDataProperties.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//
//

import Foundation
import CoreData


extension GyroInformation {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GyroInformation> {
        return NSFetchRequest<GyroInformation>(entityName: "GyroInformation")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var time: Double
    @NSManaged public var graphMode: String?
    
    var graphModeValue: GraphMode {
        get {
            return GraphMode(rawValue: graphMode ?? "gyro") ?? .gyro
        } set {
            graphMode = newValue.rawValue
        }
    }
}
