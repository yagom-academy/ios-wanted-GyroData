//
//  Double+Extension.swift
//  GyroData
//
//  Created by stone, LJ on 2023/02/02.
//

import Foundation

extension Double {
    func decimalPlace(_ decimalPoint: Int) -> Double {
        var point: Double = 1
        
        for _ in 0...decimalPoint {
            point *= 10
        }
        return floor(self * point) / point
    }
    
    func timeDecimal() -> Double? {
        return Double(String(format: "%.1f", self))
    }
}
