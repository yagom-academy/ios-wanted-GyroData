//
//  Date +.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/01/31.
//

import Foundation

extension Date {

    func makeSlashFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/DD HH:mm:ss"
        
        return dateFormatter.string(from: self)
    }
}
