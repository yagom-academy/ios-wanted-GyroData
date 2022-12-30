//
//  CoreMotionManager.swift
//  GyroData
//
//  Created by TORI on 2022/12/30.
//

import Foundation
import CoreMotion

final class CoreMotionManager {
    
    let motion = CMMotionManager()
    var timer: Timer?
    
    func startGyros(completion: @escaping (GyroItem) -> ()) {
       if motion.isGyroAvailable {
          motion.gyroUpdateInterval = 1.0 / 60.0
          motion.startGyroUpdates()

          timer = Timer(fire: Date(), interval: (1.0/60.0),
                 repeats: true, block: { (timer) in
             if let data = self.motion.gyroData {
                 let x = data.rotationRate.x
                 let y = data.rotationRate.y
                 let z = data.rotationRate.z
                 
                 let item = GyroItem(x: x, y: y, z: z)
                 completion(item)
             }
          })
           RunLoop.current.add(timer!, forMode: .default)
       }
    }

    func stopGyros() {
       if timer != nil {
          timer?.invalidate()
          timer = nil

          motion.stopGyroUpdates()
       }
    }
}
