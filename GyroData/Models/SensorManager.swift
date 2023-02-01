//
//  sensorManager.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/31.
//

import CoreMotion

class SensorManager {
    private let motionManager = CMMotionManager()
    private var timer: Timer?

    func measure(sensor: Sensor, interval: TimeInterval, timeout: TimeInterval, completion: @escaping (AxisValue?) -> ()) {
        // 측정중에 측정버튼 누르는 경우 타이머 초기화해주기 위함
        if timer != nil {
            stop(completion: nil)
        }

        timer = Timer.scheduledTimer(withTimeInterval: timeout * interval, repeats: false) { _ in
            completion(nil)
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

    func stop(completion: ((Bool) -> ())?) {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }

        if motionManager.isGyroActive {
            motionManager.stopGyroUpdates()
        }

        timer?.invalidate()
        timer = nil
        completion?(true)
    }

    private func fetchAccelerometerData(interval: TimeInterval, completion: @escaping (AxisValue) -> ()) {
        motionManager.accelerometerUpdateInterval = interval
        motionManager.startAccelerometerUpdates(to: .main) { accelerometerData, _ in
            guard let acceleration = accelerometerData?.acceleration else { return }
            completion(AxisValue(x: acceleration.x, y: acceleration.y, z: acceleration.z))
        }
    }

    private func fetchGyroData(interval: TimeInterval, completion: @escaping (AxisValue) -> ()) {
        motionManager.gyroUpdateInterval = interval
        motionManager.startGyroUpdates(to: .main) { gyroData, _ in
            guard let rotationRate = gyroData?.rotationRate else { return }
            completion(AxisValue(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z))
        }
    }
}
