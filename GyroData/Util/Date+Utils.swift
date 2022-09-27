//
//  Date+Utils.swift
//  GyroData
//
//  Created by 홍다희 on 2022/09/27.
//

import Foundation

extension Date {
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
