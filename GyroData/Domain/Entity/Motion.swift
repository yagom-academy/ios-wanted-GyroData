//
//  Motion.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

struct Motion: Identifiable {
    struct MeasurementData {
        var x: [Double]
        var y: [Double]
        var z: [Double]
        
        mutating func append(x: Double, y: Double, z: Double) {
            self.x.append(x)
            self.y.append(x)
            self.x.append(x)
        }
    }
    
    enum MeasurementType: Int {
        case acc = 0
        case gyro
        
        var text: String {
            switch self {
            case .acc:
                return "Accelerometer"
            case .gyro:
                return "Gyro"
            }
        }
    }
    
    let id: String
    let date: Date
    let type: MeasurementType
    let time: Double
    var data: MeasurementData
    
    mutating func appendData(_ motionData: MotionDataType) {
        data.append(x: motionData.x, y: motionData.y, z: motionData.z)
    }
}
