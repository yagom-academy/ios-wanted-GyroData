//
//  MotionManager.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/27.
//

import CoreMotion

final class MotionManager {
    
    // MARK: Properties
    
    private let motionType: MotionType
    private let motionManager = CMMotionManager()
    static let accelerometer = MotionManager(with: .accelerometer)
    static let gyro = MotionManager(with: .gyro)
    
    // MARK: - Initializers
    
    private init(with type: MotionType) {
        motionType = type
        commonInit()
    }
    
    // MARK: - Methods
    
    func startUpdates() {
        switch motionType {
        case .accelerometer:
            startAccelerometerRecord()
        case .gyro:
            startGyroRecord()
        }
    }
    
    func stopUpdates() {
        switch motionType {
        case .accelerometer:
            motionManager.stopAccelerometerUpdates()
        case .gyro:
            motionManager.stopGyroUpdates()
        }
    }
    
    private func commonInit() {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
    }
    
    private func startAccelerometerRecord() {
        var maxCount = 60
        motionManager.startAccelerometerUpdates(
            to: .main
        ) { [weak self] data, error in
            /// 코어데이터 저장
            print(data)
        }
        let timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { timer in
            if maxCount == 0 {
                self.motionManager.stopAccelerometerUpdates()
                timer.invalidate()
            }
 
            maxCount -= 1
        }
    }
    
    private func startGyroRecord() {
        var maxCount = 60
        motionManager.startGyroUpdates(
            to: .main
        ) { [weak self] data, error in
            /// 코어데이터 저장
            print(data)
        }
        let timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { timer in
            if maxCount == 0 {
                self.motionManager.stopGyroUpdates()
                timer.invalidate()
            }
 
            maxCount -= 1
        }
    }
}
