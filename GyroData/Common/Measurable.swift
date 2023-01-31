//
//  Measurable.swift
//  GyroData
//
//  Created by 정선아 on 2023/01/31.
//

import CoreMotion

protocol Measurable {
    var x: Double { get }
    var y: Double { get }
    var z: Double { get }
}

extension CMRotationRate: Measurable { }
extension CMAcceleration: Measurable { }
