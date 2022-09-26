//
//  CoreMotionManager.swift
//  GyroData
//
//  Created by CodeCamper on 2022/09/26.
//

import Foundation
import CoreMotion

protocol CoreMotionManagerProtocol {
    var manager: CMMotionManager { get }
    var gyroHandler: CMGyroHandler? { get set }
    var accHandler: CMAccelerometerHandler? { get set }
    func startUpdate(_ type: MotionType) throws
    func stopUpdate(_ type: MotionType)
}

class CoreMotionManager: CoreMotionManagerProtocol {
    lazy var manager: CMMotionManager = {
        let manager = CMMotionManager()
        manager.gyroUpdateInterval = 0.1
        manager.accelerometerUpdateInterval = 0.1
        return manager
    }()
    
    var gyroHandler: CMGyroHandler?
    var accHandler: CMAccelerometerHandler?
    
    func startUpdate(_ type: MotionType) throws {
        switch type {
        case .gyro:
            if let gyroHandler {
                manager.startGyroUpdates(to: OperationQueue.main, withHandler: gyroHandler)
            } else {
                throw CoreMotionError.gyroHandlerIsNil
            }
        case .acc:
            if let accHandler {
                manager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: accHandler)
            } else {
                throw CoreMotionError.accHandlerIsNil
            }
        }
    }
    
    func stopUpdate(_ type: MotionType) {
        switch type {
        case .gyro:
            manager.stopGyroUpdates()
        case .acc:
            manager.stopAccelerometerUpdates()
        }
    }
}

struct MotionMeasure: Equatable {
    var x: Double
    var y: Double
    var z: Double
    
    init(_ data: CMGyroData) {
        self.x = data.rotationRate.x
        self.y = data.rotationRate.y
        self.z = data.rotationRate.z
    }
    
    init(_ data: CMAccelerometerData) {
        self.x = data.acceleration.x
        self.y = data.acceleration.y
        self.z = data.acceleration.z
    }
}

enum MotionType: String {
    case gyro = "GYRO"
    case acc = "ACC"
}

enum CoreMotionError: Error {
    case gyroHandlerIsNil
    case accHandlerIsNil
}
