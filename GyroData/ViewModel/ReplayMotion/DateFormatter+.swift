//
//  DateFormatter+.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import Foundation

extension DateFormatter {
    
    static let measurementFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        return dateFormatter
    }()
}
