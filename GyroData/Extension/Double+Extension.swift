//
//  Double+Extension.swift
//  GyroData
//
//  Created by brad on 2022/12/28.
//

extension Double {
    func timeDecimal() -> Double {
        let result = String(format: "%.1f", self)
        
        return Double(result) ?? 0.0
    }
    
    func axisDecimal() -> Double {
        let result = String(format: "%.2f", self)
        
        return Double(result) ?? 0.0
    }
}
