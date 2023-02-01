//
//  CoreMotionManager.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.

import CoreMotion

protocol CoreMotionDelegate: AnyObject {
    func coreMotionManager(transitionData: CMLogItem)
}

class CoreMotionManager {
    private let motionMonitor = CMMotionManager()
    private var timer: Timer?
    private var time: Int = 0
    
    weak var delegate: CoreMotionDelegate?
    
    init() {
        motionMonitor.accelerometerUpdateInterval = 0.1
        motionMonitor.gyroUpdateInterval = 0.1
    }
    
    func startUpdateData(with type: SensorType) {
        guard checkAvailable(sensor: type) else { return }
        monitoringStart(sensor: type)
    }

    func cancelUpdateData() {
        if motionMonitor.isAccelerometerActive {
            motionMonitor.stopAccelerometerUpdates()
        }
        
        if motionMonitor.isGyroActive {
            motionMonitor.stopGyroUpdates()
        }
    }
}

// MARK: - ObjcMethod
private extension CoreMotionManager {
    @objc func updateAccelerometer() {
        time += 1
        
        if time > 600 {
            resetTimer()
            return
        }
        
        motionMonitor.startAccelerometerUpdates()
        if let value = motionMonitor.accelerometerData {
            delegate?.coreMotionManager(transitionData: value)
        }
    }
    
    @objc func updateGyro() {
        time += 1
        
        if time > 600 {
            resetTimer()
            return
        }
        
        motionMonitor.startGyroUpdates()
        if let value = motionMonitor.gyroData {
            delegate?.coreMotionManager(transitionData: value)
        }
    }
}

// MARK: - CoreMotion with Timer
private extension CoreMotionManager {
    func checkAvailable(sensor: SensorType) -> Bool {
        switch sensor {
        case .Accelerometer:
            return motionMonitor.isAccelerometerAvailable
        case .Gyro:
            return motionMonitor.isGyroAvailable
        }
    }
    
    func monitoringStart(sensor: SensorType) {
        switch sensor {
        case .Accelerometer:
            timer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(updateAccelerometer),
                userInfo: nil,
                repeats: true
            )
        case .Gyro:
            timer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(updateGyro),
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        cancelUpdateData()
        timer = nil
        time = 0
    }
}
