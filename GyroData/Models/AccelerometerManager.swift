//
//  AccelerometerManager.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/30.
//

import CoreMotion

class AccelerometerManager {
    private let motionManager = CMMotionManager()
    private var timer: Timer?
    private var sensorTimer: Timer?

    func measure(interval: TimeInterval = 0.1, timeout: TimeInterval = 600, completion: @escaping (CMAcceleration) -> ()) {
        motionManager.accelerometerUpdateInterval = interval
        motionManager.startAccelerometerUpdates()

        timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { [weak self] _ in
            self?.stop()
        }

        sensorTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let acceleration = self?.motionManager.accelerometerData?.acceleration else { return }

            completion(acceleration)
        }
    }

    func stop() {
        motionManager.stopAccelerometerUpdates()
        timer?.invalidate()
        sensorTimer?.invalidate()
    }
}
