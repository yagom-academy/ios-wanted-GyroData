//
//  Date+Extension.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.
        

import Foundation

extension Date {
    static let formatter = DateFormatter()
    
    func fileName() -> String {
        let formatter = Date.formatter
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self) + "_" + UUID().uuidString + ".json"
    }
}
