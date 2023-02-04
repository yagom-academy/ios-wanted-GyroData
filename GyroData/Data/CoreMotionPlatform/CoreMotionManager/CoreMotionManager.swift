//
//  CoreMotionManager.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import CoreMotion

final class CoreMotionManager {
    static let shared = CoreMotionManager()
    
    typealias Response = ((CMAccelerometerData?) -> Void)?
    
    lazy var motionManager: CMMotionManager = {
        let motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
        return motionManager
    }()
    var backgroundOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .background
        return queue
    }()
}
