//
//  GyroListViewModel.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import Combine

final class GyroListViewModel {
    private let gyroDataManager = GyroDataManager.shared
    
    func gyroDataPublisher() -> AnyPublisher<[GyroData], Never> {
        return gyroDataManager.$gyroDataList
            .eraseToAnyPublisher()
    }
}
