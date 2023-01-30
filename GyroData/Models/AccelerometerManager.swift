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
    private var sensorTimer = Timer()

    func measure(interval: TimeInterval, timeout: TimeInterval, completion: @escaping (axis) -> ()) {
        motionManager.accelerometerUpdateInterval = interval
        motionManager.startAccelerometerUpdates()

        timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { [weak self] _ in
            self?.stop()
        }

        sensorTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let acceleration = self?.motionManager.accelerometerData?.acceleration else { return }

            completion(axis(x: acceleration.x, y: acceleration.y, z: acceleration.z))
        }
    }

    func stop() {
        motionManager.stopAccelerometerUpdates()
        timer.invalidate()
        sensorTimer.invalidate()
    }
}
