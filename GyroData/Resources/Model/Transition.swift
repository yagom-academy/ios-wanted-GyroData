//
//  Transition.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.
        

import Foundation

typealias TransitionValue = (Double, Double, Double)

struct Transition: Codable {
    var x: [Double]
    var y: [Double]
    var z: [Double]
}
