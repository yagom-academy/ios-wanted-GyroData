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
    var saveDate: String
    var pageType: PageType
    
    init(title: String, second: Double, pageType: PageType = .view) {
        self.id = UUID().uuidString
        self.title = title
        self.second = second
        self.pageType = pageType
        self.saveDate = ""
    }
    
    init(id: String, title: String, second: Double, date: String, pageType: PageType) {
        self.id = id
        self.title = title
        self.second = second
        self.saveDate = date
        self.pageType = pageType
    }
        
    
}


