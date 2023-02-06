//
//  DateFormatter+Extension.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/04.
//

import Foundation

extension DateFormatter {
    static func convertDate(_ date: Date) -> String {
        let formmater = DateFormatter()
        formmater.dateFormat = "YYYY/MM/dd HH:mm:ss"
        return formmater.string(from: date)
    }
}
