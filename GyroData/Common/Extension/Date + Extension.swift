//
//  Date +.swift
//  GyroData
//
//  Created by ash and som on 2023/02/01.
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
