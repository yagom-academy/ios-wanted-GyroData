//
//  ListViewModel.swift
//  GyroData
//
//  Created by 이원빈 on 2022/12/26.
//

import Foundation

protocol ListViewModelInput {
    var model: MeasuredData { get }
}

protocol ListViewModelOutput {
    func configure() -> CellData
}

protocol ListViewModel: ListViewModelInput, ListViewModelOutput {}

final class DefaultListViewModel: ListViewModel {
    var model: MeasuredData
    
    init(model: MeasuredData) {
        self.model = model
    }
    
    func configure() -> CellData {

        return CellData(date: model.date.translateToString(), measuredTime: "", sensor: "")
    }
}
