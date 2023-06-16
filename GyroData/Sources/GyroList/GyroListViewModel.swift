//
//  GyroListViewModel.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import Combine
import Foundation

final class GyroListViewModel {
    private let gyroDataManager = GyroDataManager.shared
    
    func gyroDataPublisher() -> AnyPublisher<[GyroData], Never> {
        return gyroDataManager.$gyroDataList
            .eraseToAnyPublisher()
    }
    
    func isNoMoreDataPublisher() -> AnyPublisher<Bool, Never> {
        return gyroDataManager.$isNoMoreData
            .eraseToAnyPublisher()
    }
    
    func formatGyroDataToString(gyroData: GyroData) -> (date: String?, duration: String, dataType: String)? {
        guard let date = gyroData.date else { return nil }
        
        let formattedDate = DateFormatter.dateToText(date)
        let formattedDuration = String(format: "%.1f", gyroData.duration)
        let formattedDataType = gyroData.dataType.description
        
        return (formattedDate, formattedDuration, formattedDataType)
    }
    
    func deleteGyroData(at index: Int) {
        gyroDataManager.delete(at: index)
    }
    
    func requestFetch() {
        gyroDataManager.read()
    }
}
