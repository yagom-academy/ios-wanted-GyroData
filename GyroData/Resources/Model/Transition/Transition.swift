//
//  Transition.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.
        

import Foundation

typealias TransitionValue = (Double, Double, Double)

struct Transition: Codable {
    let values: [Tick]
}

struct Tick: Codable {
    let x: Double
    let y: Double
    let z: Double
}
