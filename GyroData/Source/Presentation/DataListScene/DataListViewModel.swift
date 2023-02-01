//
//  DataListViewModel.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/31.
//

import Foundation

final class DataListViewModel {
    private var measureDatas:[MeasureData] = [] {
        didSet {
            dataHandler?(measureDatas)
        }
    }
    
    private var dataHandler: (([MeasureData]) -> Void)?
}

extension DataListViewModel {
    func bindData(handler: @escaping ([MeasureData]) -> Void) {
        dataHandler = handler
    }
}
