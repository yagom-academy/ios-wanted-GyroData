//
//  MotionManager.swift
//  GyroData
//
//  Created by 신동원 on 2022/09/25.
//

import CoreMotion

class MotionManager: CMMotionManager {
    
    static var shared = MotionManager()
    
    override func startGyroUpdates() {
        
        gyroUpdateInterval = 0.1
        startGyroUpdates(to: OperationQueue.current!) { (gyroData: CMGyroData!, error: Error!) -> Void in
            self.reponseGyroscope(gyroData.rotationRate)
        }
    }
    
    override func startAccelerometerUpdates() {
        
        accelerometerUpdateInterval = 0.1
        startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData: CMAccelerometerData!, error: Error!) -> Void in
            self.responseAcceleration(accelerometerData.acceleration)
            
            if (error != nil) {
                print("error")
            }
        }
    }
    
    func responseAcceleration(_ acceleration: CMAcceleration) {
        print(acceleration.x)
        print(acceleration.y)
        print(acceleration.z)
        print(acceleration)
    }
    
    func reponseGyroscope(_ gyroscope: CMRotationRate) {
        print(gyroscope.x)
        print(gyroscope.y)
        print(gyroscope.z)
        print(gyroscope)
    }
    
    
}
