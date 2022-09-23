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
}
