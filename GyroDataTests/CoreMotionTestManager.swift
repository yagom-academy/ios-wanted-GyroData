//
//  CoreDataTestManager.swift
//  GyroDataTests
//
//  Created by CodeCamper on 2022/09/26.
//

@testable import GyroData
import CoreMotion

class CoreMotionTestManager: CoreMotionManagerProtocol {
    var manager = CMMotionManager()
    
    var gyroHandler: CMGyroHandler?
    
    var accHandler: CMAccelerometerHandler?
    
    func startUpdate(_ type: MotionType) throws {
        switch type {
        case .gyro:
            for _ in 0..<10 {
                gyroHandler?(TestableCMGyroData(), nil)
            }
        case .acc:
            for _ in 0..<10 {
                accHandler?(TestableCMAccelerometerData(), nil)
            }
        }
    }
    
    func stopUpdate(_ type: MotionType) {
        
    }
}

class TestableCMGyroData: CMGyroData {
    override var rotationRate: CMRotationRate {
        get {
            return CMRotationRate(
                x: Double.random(in: -2...2),
                y: Double.random(in: -2...2),
                z: Double.random(in: -2...2))
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TestableCMAccelerometerData: CMAccelerometerData {
    override var acceleration: CMAcceleration {
        get {
            return CMAcceleration(
                x: Double.random(in: -2...2),
                y: Double.random(in: -2...2),
                z: Double.random(in: -2...2))
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
