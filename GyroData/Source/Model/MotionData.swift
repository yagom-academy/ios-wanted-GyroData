//
//  MotionDataModel.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/01/31.
//

struct MotionData: Codable {
    let x: Double
    let y: Double
    let z: Double
}

struct MotionDatas: Codable {
    let datas: [MotionData]
}
