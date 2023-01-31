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

    func measure(sensor: Sensor, interval: TimeInterval, timeout: TimeInterval, completion: @escaping (AxisData?) -> ()) {
        timer = Timer.scheduledTimer(withTimeInterval: timeout * interval, repeats: false) { [weak self] _ in
            self?.stop { _ in
                completion(nil)
            }
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

    func stop(completion: @escaping (Bool) -> ()) {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }

        if motionManager.isGyroActive {
            motionManager.stopGyroUpdates()
        }

        timer.invalidate()
        completion(true)
    }

    private func fetchAccelerometerData(interval: TimeInterval, completion: @escaping (AxisData) -> ()) {
        motionManager.accelerometerUpdateInterval = interval
        motionManager.startAccelerometerUpdates(to: .main) { accelerometerData, _ in
            guard let acceleration = accelerometerData?.acceleration else { return }
            print(acceleration)
            completion(AxisData(x: acceleration.x, y: acceleration.y, z: acceleration.z))
        }
    }

    private func fetchGyroData(interval: TimeInterval, completion: @escaping (AxisData) -> ()) {
        motionManager.gyroUpdateInterval = interval
        motionManager.startGyroUpdates(to: .main) { gyroData, _ in
            guard let rotationRate = gyroData?.rotationRate else { return }
            print(rotationRate)
            completion(AxisData(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z))
        }
    }
}
