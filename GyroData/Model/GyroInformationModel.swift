//
//  GyroInformationModel.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import Foundation

struct GyroInformationModel: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var time: TimeInterval
    var graphMode: GraphMode
}
