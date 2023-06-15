//
//  GyroEntity+CoreDataClass.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/15.
//
//

import Foundation
import CoreData

@objc(GyroEntity)
public class GyroEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GyroEntity> {
        return NSFetchRequest<GyroEntity>(entityName: "GyroEntity")
    }

    @NSManaged public var axisX: [Double]?
    @NSManaged public var axisY: [Double]?
    @NSManaged public var axisZ: [Double]?
    @NSManaged public var dataTypeRawValue: Int16
    @NSManaged public var identifier: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var duration: Double
}

extension GyroEntity : DataAccessObject {
    func setValues(from model: GyroData) {
        axisX = []
        axisY = []
        axisZ = []
        
        model.coordinateList.forEach { coordinate in
            axisX?.append(coordinate.x)
            axisY?.append(coordinate.y)
            axisZ?.append(coordinate.z)
        }

        dataTypeRawValue = Int16(model.dataType.rawValue)
        identifier = model.identifier
        date = model.date
        duration = model.duration
    }
}

protocol DataAccessObject: Identifiable {
    associatedtype DataTransferObject
    
    var identifier: UUID? { get }
    
    func setValues(from model: DataTransferObject)
}
