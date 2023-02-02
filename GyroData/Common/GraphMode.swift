//
//  GraphMode.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

enum GraphMode: String, Codable {
    case acc = "acc"
    case gyro = "gyro"

    var option: Int {
        switch self {
        case .acc:
            return 0
        case .gyro:
            return 1
        }
    }

    var description: String {
        switch self {
        case .acc:
            return "Acc"
        case .gyro:
            return "Gyro"
        }
    }
}
