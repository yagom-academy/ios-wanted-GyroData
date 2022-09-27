//
//  Date+Extension.swift
//  GyroData
//
//  Created by 신병기 on 2022/09/27.
//

import Foundation

extension Date {
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss.S"
        return formatter.string(from: self)
    }
}
