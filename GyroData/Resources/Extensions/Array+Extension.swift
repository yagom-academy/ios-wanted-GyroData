//
//  Array+Extension.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension Array where Element == (Double, Double, Double) {
    func convertTransition() -> Transition {
        let xValues = self.map { round($0.0 * 1000) }.map { $0 / 1000.0 }
        let yValues = self.map { round($0.0 * 1000) }.map { $0 / 1000.0 }
        let zValues = self.map { round($0.0 * 1000) }.map { $0 / 1000.0 }
        return Transition(x: xValues, y: yValues, z: zValues)
    }
}
