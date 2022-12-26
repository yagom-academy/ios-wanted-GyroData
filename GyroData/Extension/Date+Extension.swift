//
//  Date+Extension.swift
//  GyroData
//
//  Created by brad on 2022/12/26.
//

import Foundation

extension Date {
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        return dateFormatter
    }
    
    func translateToString() -> String {
        
        return dateFormatter.string(from: self)
    }
}
