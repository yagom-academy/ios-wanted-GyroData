//
//  GraphModel.swift
//  GyroData
//
//  Created by Ellen J on 2022/12/30.
//

import Foundation

class EnvironmentGraphModel: ObservableObject {
    @Published var graphModels: [GraphModel] = []
}

struct GraphModel: Codable {
    let x: Double
    let y: Double
    let z: Double
    let measurementTime: Double
}
