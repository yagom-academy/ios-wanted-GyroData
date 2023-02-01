//
//  Double+Extension.swift
//  GyroData
//
//  Created by leewonseok on 2023/02/01.
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
}
