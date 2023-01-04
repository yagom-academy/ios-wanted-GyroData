//
//  MotionEntity+CoreDataProperties.swift
//  GyroData
//
//  Created by 이은찬 on 2022/12/29.
//
//

import Foundation
import CoreData


extension MotionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionEntity> {
        return NSFetchRequest<MotionEntity>(entityName: "MotionEntity")
    }
    
    @nonobjc public class func fetchRequestWithOptions(offset:Int) -> NSFetchRequest<MotionEntity> {
           let nsFetchRequest =  NSFetchRequest<MotionEntity>(entityName: "MotionEntity")
           nsFetchRequest.fetchLimit = 10
           nsFetchRequest.fetchOffset = offset
           return nsFetchRequest
    }

    @NSManaged public var date: String?
    @NSManaged public var measurementType: String?
    @NSManaged public var runtime: String?
    @NSManaged public var motionX: [Double]
    @NSManaged public var motionY: [Double]
    @NSManaged public var motionZ: [Double]

}

extension MotionEntity : Identifiable {

}
