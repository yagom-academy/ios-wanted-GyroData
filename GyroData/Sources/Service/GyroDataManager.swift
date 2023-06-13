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
    
    private init() {
        // for test
        var gyroData = GyroData(dataType: .accelerometer)
        gyroData.add(Coordinate(x: 1, y: -1.2, z: -3.444))
        create(gyroData)
    }
    
    func create(_ data: GyroData) {
        gyroDataList.insert(data, at: 0)
    }
}
