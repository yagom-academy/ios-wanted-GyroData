//
//  MotionInfo+CoreDataProperties.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/28.
//
//

import Foundation
import CoreData


extension MotionInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionInfo> {
        return NSFetchRequest<MotionInfo>(entityName: "MotionInfo")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var motionType: String?
    @NSManaged public var time: Double

    var motion: MotionType {
        get {
            guard let motionType = motionType else { return .acc }

            return MotionType(rawValue: motionType) ?? .acc
        }
        set {
            motionType = newValue.rawValue
        }
    }
}

extension MotionInfo : Identifiable {

}
