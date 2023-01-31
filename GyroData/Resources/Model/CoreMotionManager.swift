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
    private var time: Int = 0
    
    weak var delegate: CoreMotionDelegate?
    
    init() {
        motionMonitor.accelerometerUpdateInterval = 0.1
        motionMonitor.gyroUpdateInterval = 0.1
    }
    
    func startUpdateData(with type: SensorType) {
        switch type {
        case .Accelerometer:
            monitoringAccelerometer()
        case .Gyro:
            monitoringGyro()
        }
    }
    
    func monitoringAccelerometer() {
        guard motionMonitor.isAccelerometerAvailable else { return }
        motionMonitor.startAccelerometerUpdates(to: .main, withHandler: handleLogData)
    }
    
    func monitoringGyro() {
        guard motionMonitor.isGyroAvailable else { return }
        motionMonitor.startGyroUpdates(to: .main, withHandler: handleLogData)
    }
    
    func handleLogData(data: CMLogItem?, error: Error?) {
        guard error == nil, let data = data else { return }
        time += 1
        
        guard time <= 600 else {
            cancelUpdateData()
            return
        }
        
        delegate?.coreMotionManager(transitionData: data)
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
