//
//  sensorManager.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/31.
//

import CoreMotion

class SensorManager {
    private let motionManager = CMMotionManager()
    private var timer = Timer()

    func measure(sensor: Sensor, interval: TimeInterval, timeout: TimeInterval, completion: @escaping (Axis) -> ()) {
        timer = Timer.scheduledTimer(withTimeInterval: timeout * interval, repeats: false) { [weak self] _ in
            self?.stop()
        }

        switch sensor {
        case .Accelerometer:
            fetchAccelerometerData(interval: interval) { data in
                completion(data)
            }
        case .Gyro:
            fetchGyroData(interval: interval) { data in
                completion(data)
            }
        }
    }

    func stop() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }

        if motionManager.isGyroActive {
            motionManager.stopGyroUpdates()
        }

        timer.invalidate()
    }

    private func fetchAccelerometerData(interval: TimeInterval, completion: @escaping (Axis) -> ()) {
        motionManager.accelerometerUpdateInterval = interval
        motionManager.startAccelerometerUpdates(to: .main) { accelerometerData, _ in
            guard let acceleration = accelerometerData?.acceleration else { return }
            print(acceleration)
            completion(Axis(x: acceleration.x, y: acceleration.y, z: acceleration.z))
        }
    }

    private func fetchGyroData(interval: TimeInterval, completion: @escaping (Axis) -> ()) {
        motionManager.gyroUpdateInterval = interval
        motionManager.startGyroUpdates(to: .main) { gyroData, _ in
            guard let rotationRate = gyroData?.rotationRate else { return }
            print(rotationRate)
            completion(Axis(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z))
        }
    }
}
