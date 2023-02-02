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
    func bindData(handler: @escaping (MeasureData) -> Void) {
        handler(measureData)
    }
}
