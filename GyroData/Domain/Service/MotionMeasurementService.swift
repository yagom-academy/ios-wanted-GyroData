//
//  MotionMeasurementService.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/02/02.
//

import CoreMotion

final class MotionMeasurementService: MotionMeasurable {
    enum Constant {
        static let timeInterval: Double = 0.1
        static let timeLimit: Double = 60.0
    }
    private let measurementQueue = OperationQueue()
    private let motionManager = CMMotionManager()
    
    func measure(
        type: Motion.MeasurementType,
        measurementHandler: @escaping (MotionDataType) -> Void,
        completeHandler: @escaping (Bool) -> Void
    ) {
        switch type {
        case .acc:
            measureAccelerometer(
                measurementHandler: measurementHandler,
                completeHandler: completeHandler)
        case .gyro:
            measureGyro(
                measurementHandler: measurementHandler,
                completeHandler: completeHandler)
        }
    }
    
    func stopMeasurement(type: Motion.MeasurementType) {
        switch type {
        case .acc:
            motionManager.stopAccelerometerUpdates()
        case .gyro:
            motionManager.stopGyroUpdates()
        }
    }
}

private extension MotionMeasurementService {
    func measureAccelerometer(
        measurementHandler: @escaping (MotionDataType) -> Void,
        completeHandler: @escaping (Bool) -> Void
    ) {
        var currentTime: Double = .zero
        motionManager.accelerometerUpdateInterval = Constant.timeInterval
        motionManager.startAccelerometerUpdates(to: measurementQueue) { [weak self] data, error in
            guard let data = data, currentTime < Constant.timeLimit else {
                completeHandler(true)
                self?.stopMeasurement(type: .acc)
                return
            }
            measurementHandler(data.acceleration)
            currentTime += Constant.timeInterval
        }
    }
    
    func measureGyro(
        measurementHandler: @escaping (MotionDataType) -> Void,
        completeHandler: @escaping (Bool) -> Void
    ) {
        var currentTime: Double = .zero
        motionManager.gyroUpdateInterval = Constant.timeInterval
        motionManager.startGyroUpdates(to: measurementQueue) { [weak self] data, error in
            guard let data = data, currentTime < Constant.timeLimit else {
                completeHandler(true)
                self?.stopMeasurement(type: .gyro)
                return
            }
            measurementHandler(data.rotationRate)
            currentTime += Constant.timeInterval
        }
    }
}
