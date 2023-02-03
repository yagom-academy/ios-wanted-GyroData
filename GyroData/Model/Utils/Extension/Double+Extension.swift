//
//  Double+Extension.swift
//  GyroData
//
//  Created by stone, LJ on 2023/02/02.
//

import Foundation

extension Double {
    func decimalPlace(_ decimalPoint: Int) -> Double {
        return Double(String(format: "%.\(decimalPoint)f", self)) ?? 0.0
    }
}
