//
//  GyroData.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import Foundation

final class GyroData {
    enum DataType {
        case accelerometer
        case gyro
        
        var description: String {
            switch self {
            case .accelerometer:
                return "Accelerometer"
            case .gyro:
                return "Gyro"
            }
        }
    }
    
    private let dataType: DataType
    private var queue = LimitedQueue<Coordinate>()
    private var date: Date?
    private var duration: Double? {
        let duration = Double(queue.count) / 10.0
        let formattedDuration = String(format: "%.1f", duration)
        
        return Double(formattedDuration)
    }
    
    init(dataType: DataType) {
        self.dataType = dataType
    }
    
    func add(_ data: Coordinate) {
        queue.enqueue(data)
        date = Date()
    }
}
