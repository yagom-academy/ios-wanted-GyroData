//
//  MotionManagerType.swift
//  GyroData
//
//  Created junho, summercat on 2023/01/31.
//

import Foundation

protocol MotionManagerType {
    func startAccelerometer(_ closure: @escaping (Coordinate) -> Void)
    func stopAccelerometer()
    func startGyro(_ closure: @escaping (Coordinate) -> Void)
    func stopGyro()
}
