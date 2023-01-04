//
//  Date+.swift
//  GyroData
//
//  Created by Ellen J, unchain, yeton on 2022/12/29.
//

import Foundation

extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "KRW")
        return dateFormatter.string(from: self)
    }
}
