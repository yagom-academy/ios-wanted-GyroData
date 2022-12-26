//
//  CoreMotionManager.swift
//  GyroData
//
//  Created by Ari on 2022/12/26.
//

import Foundation
import CoreMotion

final class CoreMotionManager {
    
    private let manager: CMMotionManager
    private let queue: OperationQueue
    private var gyroHandler: CMGyroHandler?
    private var accHandler: CMAccelerometerHandler?
    
    init(
        manager: CMMotionManager = {
            let manager = CMMotionManager()
            manager.gyroUpdateInterval = 0.1
            manager.accelerometerUpdateInterval = 0.1
            return manager
        }(),
        queue: OperationQueue = .init()
    ) {
        self.manager = manager
        self.queue = queue
    }
    
}

extension CoreMotionManager {
    
    func startUpdates(type: MotionType) {
        switch type {
        case .accelerometer:
            guard let accHandler else {
                return
            }
            manager.startAccelerometerUpdates(to: queue, withHandler: accHandler)
            
        case .gyro:
            guard let gyroHandler else {
                return
            }
            manager.startGyroUpdates(to: queue, withHandler: gyroHandler)
        }
    }
    
    func stopUpdates(type: MotionType) {
        switch type {
        case .accelerometer: manager.stopAccelerometerUpdates()
        case .gyro: manager.stopGyroUpdates()
        }
    }
    
    func bind(accHandler: @escaping CMAccelerometerHandler) {
        self.accHandler = accHandler
    }
    
    func bind(gyroHandler: @escaping CMGyroHandler) {
        self.gyroHandler = gyroHandler
    }

}
