//
//  MotionMeasureManager.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/01.
//

import CoreMotion
import Foundation

protocol MotionManagerable {
    func start(handler: @escaping () -> Void)
    func stop()
}

final class GyroMotionManager: MotionManagerable {
    private let motionManager = CMMotionManager()
    
    func start(handler: @escaping () -> Void) {
        
    }

    func stop() {
        motionManager.stopGyroUpdates()
    }
}

final class AccelerometerMotionManager: MotionManagerable {
    private let motionManager = CMMotionManager()
    
    func start(handler: @escaping () -> Void) {
        
    }
    
    func stop() {
        motionManager.stopAccelerometerUpdates()
    }
}
