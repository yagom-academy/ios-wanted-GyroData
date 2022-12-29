//
//  UIDate+.swift
//  GyroData
//
//  Created by 이예은 on 2022/12/29.
//

import Foundation

extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}
