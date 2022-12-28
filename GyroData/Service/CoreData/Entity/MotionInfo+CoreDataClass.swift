//
//  MotionInfo+CoreDataClass.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/28.
//
//

import Foundation
import CoreData

@objc(MotionInfo)
public class MotionInfo: NSManagedObject {
    struct Constant {
        static let date = "date"
        static let entitiyName = "MotionInfo"
    }
}
