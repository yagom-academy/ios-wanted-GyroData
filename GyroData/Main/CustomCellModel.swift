//
//  Model.swift
//  GyroData
//
//  Created by so on 2022/09/22.
//

import Foundation


struct CustomCellModel {
    let dataTypeLabel: String
    let valueLabel: String
    let dateLabel: String
}


struct Notice: Codable, Equatable {
    var title: String
    var second: Double
    var measureDate: Date
    var id: UUID
}
