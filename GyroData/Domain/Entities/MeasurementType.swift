//
//  MeasurementType.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/27.
//

enum MeasurementType {
    case acc
    case gyro
    
    var name: String {
        switch self {
        case .acc:
            return "Acc"
        case .gyro:
            return "Gyro"
        }
    }
    var number: Int {
        switch self {
        case .acc:
            return 0
        default:
            return 1
        }
    }
}
