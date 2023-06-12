//
//  GyroData.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

final class GyroData {
    enum DataType {
        case accelerometer
        case gyro
    }
    
    private let dataType: DataType
    private var queue = LimitedQueue<Coordinate>()
    
    init(dataType: DataType) {
        self.dataType = dataType
    }
    
    func add(_ data: Coordinate) {
        queue.enqueue(data)
    }
}
