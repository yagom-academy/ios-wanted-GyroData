//
//  GyroDataManager.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import Combine

final class GyroDataManager {
    static let shared = GyroDataManager()
    
    @Published var gyroDataList: [GyroData] = []
    
    private init() {}
    
    func create(_ data: GyroData) {
        gyroDataList.insert(data, at: 0)
    }
}
