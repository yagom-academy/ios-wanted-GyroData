//
//  MotionDataEntity+CoreDataProperties.swift
//  GyroData
//
//  Created by Aaron on 2023/01/31.
//
//

import Foundation
import CoreData


extension MotionDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionDataEntity> {
        return NSFetchRequest<MotionDataEntity>(entityName: "MotionDataEntity")
    }

    @NSManaged public var date: Date
    @NSManaged public var type: String
    @NSManaged public var time: Double
    @NSManaged public var xValue: [Double]
    @NSManaged public var yValue: [Double]
    @NSManaged public var zValue: [Double]
    @NSManaged public var id: UUID
}

extension MotionDataEntity : Identifiable { }

extension MotionDataEntity {
    
    func toDomain() -> MotionData {
        let xyValue: [SIMD2<Double>] = zip(xValue, yValue).map { SIMD2(x: $0, y: $1) }
        let value: [SIMD3<Double>] = zip(xyValue, zValue).map { SIMD3($0, $1) }
        
        return MotionData(date: date,
                          type: MotionType(rawValue: type) ?? .accelerometer,
                          time: time,
                          value: value,
                          id: id)
    }
}
