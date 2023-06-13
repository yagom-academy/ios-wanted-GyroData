//
//  GyroDataTableCellViewModel.swift
//  GyroData
//
//  Created by 리지 on 2023/06/12.
//

import Combine

final class GyroDataTableCellViewModel {
    @Published private(set) var sixAxisData: GyroEntity
    
    init(sixAxisData: GyroEntity) {
        self.sixAxisData = sixAxisData
    }
}
