//
//  MotionMeasurementManager.swift
//  GyroData
//
//  Created by Judy on 2022/12/28.
//

import CoreMotion

class MotionMeasurementManager {
    static let shared = MotionMeasurementManager()
    private let motionManager = CMMotionManager()
    private var timer: Timer?
    
    private init() {
        motionManager.accelerometerUpdateInterval = MotionMeasurementNumber.updateInterval
        motionManager.gyroUpdateInterval = MotionMeasurementNumber.updateInterval
    }
    
    func stopMeasurement(_ type: MotionType) {
        guard let currentTimer = timer else { return }
        
        currentTimer.invalidate()
        timer = nil
        
        switch type {
        case .acc:
            motionManager.stopAccelerometerUpdates()
        case .gyro:
            motionManager.stopGyroUpdates()
        }
    }
    
    func startMeasurement(_ motionType: MotionType, on graphView: GraphView) {
        var timeCount = Double.zero
        
        checkAvailableAndStart(motionType)
        
        timer = Timer(fire: Date(),
                      interval: MotionMeasurementNumber.updateInterval,
                      repeats: true,
                      block: { [self] (timer) in
            
            timeCount += MotionMeasurementNumber.updateInterval
            
            if checkOutofTime(timeCount) {
                timer.invalidate()
            }
            
            drawGraph(motionType, on: graphView)
        })
        
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .default)
        }
    }
    
    private func checkAvailableAndStart(_ motionType: MotionType) {
        switch motionType {
        case .acc:
            guard motionManager.isAccelerometerAvailable else { return }
  
            motionManager.startAccelerometerUpdates()
        case .gyro:
            guard motionManager.isGyroAvailable else { return }
            
            motionManager.startGyroUpdates()
        }
    }
    
    private func drawGraph(_ motionType: MotionType, on graphView: GraphView) {
        let measurementData: Measurementable?
        
        switch motionType {
        case .acc:
            measurementData = motionManager.accelerometerData?.acceleration
        case .gyro:
            measurementData = motionManager.gyroData?.rotationRate
        }
        
        guard let data = measurementData else { return }
        
        graphView.add([data.x, data.y, data.z])
    }

    private func checkOutofTime(_ value: Double) -> Bool {
        return round(value * 10) / 10 == MotionMeasurementNumber.completeTime
    }
}

fileprivate enum MotionMeasurementNumber {
    static let updateInterval = 1.0 / 10.0
    static let completeTime = 60.0
}
