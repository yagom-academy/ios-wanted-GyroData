//
//  Motion.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/27.
//

struct Motion {
    let date: String
    let measurementType: MeasurementType
    let coordinate: Coordinate
}

struct Coordinate {
    let x: [Int]
    let y: [Int]
    let z: [Int]
}
