//
//  MotionMeasureManager.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/01.
//

import CoreMotion
import Foundation

protocol MotionMeasureManagerable {
    func startGyroscope(handler: @escaping () -> Void)
    func stopGyroscope(handler: @escaping () -> Void)
    func startAccelerometer(handler: @escaping () -> Void)
    func stopAccelerometer(handler: @escaping () -> Void)
}
