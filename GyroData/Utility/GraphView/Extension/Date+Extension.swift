//
//  Date+Extension.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/30.
//

import Foundation

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
