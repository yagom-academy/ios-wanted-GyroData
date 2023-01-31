//
//  GyroData.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import Foundation

struct GyroData: Codable{
    let x: [Double]
    let y: [Double]
    let z: [Double]
    let gyroInformation: GyroInformationModel
}
