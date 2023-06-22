//
//  GyroData.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import Foundation

struct GyroData: DataTransferObject, Codable {
    enum DataType: Int, Codable {
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
    
    let identifier: UUID
    let dataType: DataType
    var coordinateList = [Coordinate]()
    var date: Date?
    var duration: Double = 0.0
    
    var count: Int {
        coordinateList.count
    }
    
    init(dataType: DataType, identifier: UUID? = nil) {
        self.dataType = dataType
        
        if let identifier {
            self.identifier = identifier
        } else {
            self.identifier = UUID()
        }
    }
    
    mutating func add(_ data: Coordinate, interval: Double) {
        coordinateList.append(data)
        duration += interval
        date = Date()
    }
    
    func readLastGyroData() -> Coordinate? {
        return coordinateList.last
    }
    
    mutating func removeFirst() -> Coordinate {
        return coordinateList.removeFirst()
    }
    
    func forEach(_ completion: (Coordinate) -> Void) {
        coordinateList.forEach { coordinate in
            completion(coordinate)
        }
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
