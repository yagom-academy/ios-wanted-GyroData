//
//  Date+extension.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import Foundation

extension Date {
    
    enum DateFormat: String {
        case display = "yyyy/MM/dd HH:mm:ss"
    }
    
    func formatted(for format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        let deviceLocale = Locale(
            identifier: Locale.preferredLanguages.first ?? "ko-kr"
        ).language.languageCode?.identifier
        dateFormatter.locale = Locale(identifier: deviceLocale ?? "ko-kr")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    
}
