//  GyroData - DateFormatter+Extension.swift
//  Created by zhilly, woong on 2023/02/04

import Foundation

extension DateFormatter {
    
    static func convertToFileFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        return dateFormatter.string(from: date)
    }
}
