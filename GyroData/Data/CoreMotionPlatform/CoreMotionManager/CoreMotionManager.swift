//
//  CoreMotionManager.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import CoreMotion

final class CoreMotionManager {
    static let shared = CoreMotionManager()
    
    private lazy var motionManager: CMMotionManager = {
        let motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
        return motionManager
    }()
    private let backgroundOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .background
        return queue
    }()
    
    func startAccelerometer(completion: @escaping (CMAccelerometerData?) -> Void ) {
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: backgroundOperationQueue) { data, error in
                completion(data)
            }
        }
    }
    
    func startGyroscope(completion: @escaping (CMGyroData?) -> Void) {
        if motionManager.isGyroAvailable {
            motionManager.startGyroUpdates(to: backgroundOperationQueue) { data, error in
                completion(data)
            }
        }
    }
    
    func stopAccelerometer() {
        motionManager.stopAccelerometerUpdates()
    }
    
    func stopGyroscope() {
        motionManager.stopGyroUpdates()
    }
}
