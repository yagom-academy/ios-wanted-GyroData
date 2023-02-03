//
//  MotionMeasurementService.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/02/02.
//

import CoreMotion

protocol MotionMeasurementServiceDelegate: AnyObject {
    func motionMeasurementService(measuredData: MotionDataType?, time: Double)
    func motionMeasurementService(isCompletedService: Bool)
}

final class MotionMeasurementService: MotionMeasurable {
    enum Constant {
        static let timeInterval: Double = 0.1
        static let timeLimit: Double = 60.0
    }
    private let measurementQueue = OperationQueue()
    private let motionManager = CMMotionManager()
    private var stopTimer: Timer?
    private weak var delegate: MotionMeasurementServiceDelegate?
    
    init() { }
    
    deinit {
        stopTimer?.invalidate()
    }
    
    func measure(type: Motion.MeasurementType) {
        switch type {
        case .acc:
            measureAccelerometer()
        case .gyro:
            measureGyro()
        }
        setTimeLimit(type: type)
    }
    
    func stopMeasurement(type: Motion.MeasurementType) {
        switch type {
        case .acc:
            motionManager.stopAccelerometerUpdates()
        case .gyro:
            motionManager.stopGyroUpdates()
        }
        delegate?.motionMeasurementService(isCompletedService: true)
        stopTimer?.invalidate()
        stopTimer = nil
    }
    
    func configureDelegate(_ delegate: MotionMeasurementServiceDelegate) {
        self.delegate = delegate
    }
}

private extension MotionMeasurementService {
    func measureAccelerometer() {
        var currentTime: Double = .zero
        motionManager.accelerometerUpdateInterval = Constant.timeInterval
        motionManager.startAccelerometerUpdates(to: measurementQueue) { [weak self] data, error in
            guard let data = data else { return }
            self?.delegate?.motionMeasurementService(measuredData: data.acceleration, time: currentTime)
            currentTime += Constant.timeInterval
        }
    }
    
    func measureGyro() {
        var currentTime: Double = .zero
        motionManager.gyroUpdateInterval = Constant.timeInterval
        motionManager.startGyroUpdates(to: measurementQueue) { [weak self] data, error in
            guard let data = data else { return }
            self?.delegate?.motionMeasurementService(measuredData: data.rotationRate, time: currentTime)
            currentTime += Constant.timeInterval
        }
    }
    
    func setTimeLimit(type: Motion.MeasurementType) {
        stopTimer = Timer.scheduledTimer(
            withTimeInterval: Constant.timeLimit,
            repeats: false
        ) { [weak self] _ in
            self?.stopMeasurement(type: type)
        }
    }
}
