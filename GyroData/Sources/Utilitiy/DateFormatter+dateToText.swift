//
//  DateFormatter+dateToText.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/14.
//

import Foundation

extension DateFormatter {
    static let dateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        
        return dateFormatter
    }()
    
    static func dateToText(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
