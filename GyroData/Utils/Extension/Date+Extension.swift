//
//  Date+Extension.swift
//  GyroData
//
//  Created by stone, LJ on 2023/02/02.
//

import Foundation

extension Date {
    public func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        return formatter.string(from: self)
    }
}
