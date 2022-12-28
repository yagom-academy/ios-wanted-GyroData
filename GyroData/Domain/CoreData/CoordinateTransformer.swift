//
//  CoordinateTransformer.swift
//  GyroData
//
//  Created by seohyeon park on 2022/12/28.
//

import Foundation

@objc(CoordinateTransformer)
class CoordinateTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
            return super.allowedTopLevelClasses + [Coordinate.self]
    }
}
