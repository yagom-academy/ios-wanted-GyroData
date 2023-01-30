//
//  Array+Extension.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension Array where Element == (Double, Double, Double) {
    func convertTransition() -> Transition {
        let xValues = self.map { $0.0 }
        let yValues = self.map { $0.1 }
        let zValues = self.map { $0.2 }
        return Transition(x: xValues, y: yValues, z: zValues)
    }
}
