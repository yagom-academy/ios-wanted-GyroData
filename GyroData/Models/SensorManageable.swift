//
//  SensorManageable.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/31.
//

import Foundation

protocol SensorManageable {
    func measure(interval: TimeInterval, timeout: Int, completion: @escaping (Axis) -> ())
    func stop()
}
