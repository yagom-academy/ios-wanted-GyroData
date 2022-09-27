//
//  DummyGenerator.swift
//  GyroData
//
//  Created by CodeCamper on 2022/09/23.
//

import Foundation

class DummyGenerator {
    static func getDummyMotionData() -> MotionTask {
        let type = Int.random(in: 0...1) % 2 == 0 ? "GYRO" : "ACC"
        let time = round(Float.random(in: 0...60) * 10) / 10
        let date = Date(timeIntervalSinceNow: Double.random(in: 0...50000))
        let path = ""
        return MotionTask(type: type, time: time, date: date, path: path)
    }
    
    static func insertDummyMotionDataToCoreData() async throws -> Bool {
        let result = try await CoreDataManager.shared.insertMotionTask(motion: DummyGenerator.getDummyMotionData())
        return result
    }
    
    static func getDummyMotionFile() -> MotionFile {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        
        let fileName = dateFormatter.string(from: Date(timeIntervalSinceNow: Double.random(in: 0...50000)))
        let type = Int.random(in: 0...1) % 2 == 0 ? "GYRO" : "ACC"
        var x_axis: [Float] = []
        var y_axis: [Float] = []
        var z_axis: [Float] = []
        
        for _  in 0..<10 {
            x_axis.append(Float.random(in: 0...1))
            y_axis.append(Float.random(in: 0...1))
            z_axis.append(Float.random(in: 0...1))
        }
        
        return MotionFile(fileName: fileName, type: type, x_axis: x_axis, y_axis: y_axis, z_axis: z_axis)
    }
}
