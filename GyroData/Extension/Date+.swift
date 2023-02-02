//
//  Date+.swift
//  GyroData
//
//  Created by junho lee on 2023/02/01.
//

import Foundation

extension Date {
    private static let dateFormatter = DateFormatter()

    func dateTimeString() -> String {
        let dateFormatter = Self.dateFormatter
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
        return dateFormatter.string(from: self)
    }
}
