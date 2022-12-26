//
//  ListViewModel.swift
//  GyroData
//
//  Created by 이원빈 on 2022/12/26.
//

import Foundation

protocol ListViewModelInput {
    var model: SensorData { get }
}

protocol ListViewModelOutput {
    func configure() -> CellData
}

protocol ListViewModel: ListViewModelInput, ListViewModelOutput {}

final class DefaultListViewModel: ListViewModel {
    var model: SensorData
    
    init(model: SensorData) {
        self.model = model
    }
    
    func configure() -> CellData {
        // 데이터 변환
        return CellData(date: "", sensorValue: "", sensor: "")
    }
}
