//
//  GyroManager.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/30.
//

import CoreMotion

class GyroManager: SensorManageable {
    func measure(interval: TimeInterval, timeout: Int, completion: @escaping (Axis) -> ()) {
        fatalError()
    }
    func stop() {
        print("자이로 측정정지")
    }
}
