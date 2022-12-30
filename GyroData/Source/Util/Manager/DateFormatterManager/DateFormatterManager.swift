//
//  DateFormatterManager.swift
//  GyroData
//
//  Created by dhoney96 on 2022/12/30.
//

import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    private let formatter = DateFormatter()
    
    var dateFormatter: DateFormatter {
        self.formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }
    
    func convertToDateString(from date: Date) -> String {
        return self.dateFormatter.string(from: date)
    }
}
