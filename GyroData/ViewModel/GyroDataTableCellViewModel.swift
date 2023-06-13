//
//  GyroDataTableCellViewModel.swift
//  GyroData
//
//  Created by 리지 on 2023/06/12.
//

import Combine

final class GyroDataTableCellViewModel {
    @Published private(set) var sixAxisData: SixAxisData
    
    init(sixAxisData: SixAxisData) {
        self.sixAxisData = sixAxisData
    }
}
