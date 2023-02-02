//
//  Double+Extension.swift
//  GyroData
//
//  Created by 임지연 on 2023/02/02.
//

import Foundation

extension Double {
    func timeDecimal() -> Double? {
        return Double(String(format: "%.1f", self))
    }
}
