//
//  DateFormatter+dateToText.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/14.
//

import Foundation

extension DateFormatter {
    static let formatterForUI = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        
        return dateFormatter
    }()
    static let formatterForJSON = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYYMMdd-HHmmss"
        
        return dateFormatter
    }()
    
    static func dateToText(_ date: Date?) -> String? {
        guard let date else { return nil }
        
        return formatterForUI.string(from: date)
    }
    
    static func dateToTextForJSON(_ date: Date?) -> String? {
        guard let date else { return nil }
        
        return formatterForJSON.string(from: date)
    }
}
