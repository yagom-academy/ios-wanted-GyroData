//
//  MeasureDataDummy.swift
//  GyroDataTests
//
//  Created by Kyo, JPush on 2023/01/31.
//

import Foundation

struct MeasureDataDummy {
    static var Dummys: [MeasureData] = [
        MeasureData(
            xValue: [1, 2, 3, 4],
            yValue: [5, 6, 7, 8],
            zValue: [9, 10, 11, 12],
            runTime: 20,
            date: Date(timeIntervalSince1970: 1),
            type: .accelerometer
        ),
        
        MeasureData(
            xValue: [10, 20, 30, 40],
            yValue: [50, 60, 70, 80],
            zValue: [90, 100, 110, 120],
            runTime: 10,
            date: Date(timeIntervalSince1970: 2),
            type: .gyroscope
        )
    ]
}
