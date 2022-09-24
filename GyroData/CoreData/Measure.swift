//
//  Measure.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/24.
//

import Foundation

struct Measure {
    var id: String
    var title: String
    var second: Double
    var measureDate: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return f.string(from: Date())
    }
    
    init(title: String, second: Double) {
        self.id = UUID().uuidString
        self.title = title
        self.second = second
    }
    
}
