//
//  SixAxisData.swift
//  GyroData
//
//  Created by 리지 on 2023/06/12.
//

import Foundation

struct SixAxisData {
    let id = UUID()
    let date: String?
    let title: SensorType?
    let record: Double?
    
    init(date: String?, title: SensorType?, record: Double?) {
        self.date = date
        self.title = title
        self.record = record
    }
}
