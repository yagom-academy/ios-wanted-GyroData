//
//  GyroData.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import Foundation

struct GyroData {
    enum DataType: Int {
        case accelerometer = 0
        case gyro = 1
        
        var description: String {
            switch self {
            case .accelerometer:
                return "Accelerometer"
            case .gyro:
                return "Gyro"
            }
        }
    }
    
    private let identifier: UUID
    let dataType: DataType
    var queue = LimitedQueue<Coordinate>()
    var date: Date?
    var duration: Double? {
        let duration = Double(queue.count) / 10.0
        let formattedDuration = String(format: "%.1f", duration)
        
        return Double(formattedDuration)
    }
    
    var count: Int {
        queue.count
    }
    
    init(dataType: DataType) {
        self.dataType = dataType
        identifier = UUID()
    }
    
    mutating func add(_ data: Coordinate) {
        queue.enqueue(data)
        date = Date()
    }
    
    func readLastGyroData() -> Coordinate? {
        return queue.peek()
    }
    
    mutating func dequeue() -> Coordinate? {
        return queue.dequeue()
    }
}

extension GyroData: Hashable {
    static func == (lhs: GyroData, rhs: GyroData) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
