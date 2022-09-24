//
//  Measure.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/24.
//

import Foundation

struct Measure {
    var id: String = UUID().uuidString
    var title: String
    var second: Double
    var measureDate: Date 
}
