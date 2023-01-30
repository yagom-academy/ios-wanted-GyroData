//
//  AccelerometerManager.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/30.
//

import CoreMotion

class AccelerometerManager: SensorManageable {
    private let motionManager = CMMotionManager()
    private var timer = Timer()

    func measure(interval: TimeInterval, timeout: Int, completion: @escaping (Axis) -> ()) {
        var count = timeout

        motionManager.accelerometerUpdateInterval = interval
        motionManager.startAccelerometerUpdates()

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            count -= 1
            if count <= 0 {
                self?.stop()
            }

            guard let acceleration = self?.motionManager.accelerometerData?.acceleration else { return }
            completion(Axis(x: acceleration.x, y: acceleration.y, z: acceleration.z))
        }
    }

    func stop() {
        motionManager.stopAccelerometerUpdates()
        timer.invalidate()
    }
}
