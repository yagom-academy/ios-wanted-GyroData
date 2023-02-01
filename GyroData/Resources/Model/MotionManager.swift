//
//  MotionManager.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.

import CoreMotion

class MotionManager {
    private let manager = CMMotionManager()
    private var time: Int = 0
    private var timer: Timer?
    
    init() {
        manager.accelerometerUpdateInterval = 0.1
        manager.gyroUpdateInterval = 0.1
    }
    
    func startRecord(with sensor: SensorType) {
        switch sensor {
        case .Accelerometer:
            startAccelerometer()
        case .Gyro:
            startGyro()
        }
    }

    func stopRecord() {
        if manager.isAccelerometerActive {
            manager.stopAccelerometerUpdates()
        }
        
        if manager.isGyroActive {
            manager.stopGyroUpdates()
        }
    }
}

private extension MotionManager {
    func startAccelerometer() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(monitoringAccelerometer),
            userInfo: nil,
            repeats: true
        )
    }
    
    func startGyro() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(monitoringGyro),
            userInfo: nil,
            repeats: true
        )
    }
    
    func lessThanLimitTime() -> Bool {
        return time <= 600
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        time = 0
    }
}

private extension MotionManager {
    @objc func monitoringAccelerometer() {
        time += 1
        guard lessThanLimitTime() else {
            resetTimer()
            return
        }
        
        guard manager.isAccelerometerAvailable else { return }
        
        manager.startAccelerometerUpdates()
        let data = manager.accelerometerData
        
    }
    
    @objc func monitoringGyro() {
        time += 1
        guard lessThanLimitTime() else {
            resetTimer()
            return
        }
        guard manager.isGyroAvailable else { return }
        
        manager.startGyroUpdates()
        let data = manager.gyroData
        
    }
}
