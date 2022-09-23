//
//  Constants.swift
//  GyroData
//
//  Created by 엄철찬 on 2022/09/23.
//

import Foundation
import UIKit

struct Constants{
    static var calibration = 1.0
    static let towardOrigin : Double  = 150
    static let startPointX  : Int     = 10
    static let startPointY  : Int     = 0
    static let lineWidth    : Double  = 0.7
    static var gyroMax      : Double  = 8       //이 기준을 넘으면 그래프 크기가 1.2배 축소된다
    static var accMax       : Double  = 4      //이 기준을 넘으면 그래프 크기가 1.2배 축소된다
    static let cornerRadiusSize       = CGSize(width: 20.0, height: 20.0)
    static let margin  : CGFloat      = 10.0
    static var currentMax   : Double  = 0.0
}
