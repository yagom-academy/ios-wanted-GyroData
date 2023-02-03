//
//  DetailViewModel.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/02.
//

import Foundation

final class DetailViewModel {
    private var measureData: MeasureData
    
    init(data: MeasureData) {
        measureData = data
    }
}

extension DetailViewModel {
    typealias Values = (x: Double, y: Double, z: Double)
    
    func bindData(handler: @escaping (MeasureData, [Values]) -> Void) {
        var segmentValues: [Values] = []

        for i in 0..<measureData.xValue.count {
            let values: Values = (measureData.xValue[i], measureData.yValue[i], measureData.zValue[i])
            segmentValues.append(values)
        }

        handler(measureData, segmentValues)
    }
}
