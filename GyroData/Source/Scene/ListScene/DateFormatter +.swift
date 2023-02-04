//
//  DateFormatter +.swift
//  GyroData
//
//  Created by inho on 2023/02/03.
//

import Foundation

extension DateFormatter {
    static let measuredDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        return dateFormatter
    }()
}
