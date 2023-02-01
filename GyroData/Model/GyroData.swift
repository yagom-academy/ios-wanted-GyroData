//
//  GyroData.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

struct GyroData: Codable {
    let gyroInformation: GyroInformationModel
    let x: [Double]
    let y: [Double]
    let z: [Double]
}
