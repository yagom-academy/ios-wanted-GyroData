//
//  Date+.swift
//  GyroData
//
//  Created by Ayaan on 2023/02/03.
//

import Foundation

extension Date {
    func formatted(by format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
