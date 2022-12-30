//
//  Motion.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/27.
//

import UIKit

struct Motion: Hashable {
    let date: String
    let measurementType: String
    let runtime: String
    let motionX: [Double]
    let motionY: [Double]
    let motionZ: [Double]
}
