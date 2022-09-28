//
//  MotionManager.swift
//  GyroData
//
//  Created by 유영훈 on 2022/09/25.
//

import Foundation
import CoreMotion

protocol MotionManagerDelegate {
    /// 정의한 interval 간격마다 실시간 모션값을 업데이트 합니다.
    func motionValueDidUpdate(data: MotionManager.MotionValue, interval: TimeInterval)
    /// 모션값 업데이트를 중단합니다.
    func motionValueUpdateDidEnd(interval: TimeInterval)
    func motionValueUpdateWillStart() -> Bool
    func motionValueUpdateWillEnd() -> Bool
}

/// 모션값 핸들링 기능을 모듈화
class MotionManager {
    
    static let shared = MotionManager()
    
    public var delegate: MotionManagerDelegate!
    
    private let manager = CMMotionManager()
    
    private var timer = Timer() {
        didSet {
            isRunning = true
            count = 0
            time = 0.0
        }
    }
    
    private var time: TimeInterval = 0.0
    
    private let MAX_COUNT: Int = 600
    private var count: Int = 0
    
    private var motionType: MotionType?
    
    public var isRunning: Bool = false
    
    enum MotionType: String {
        case acc = "Accelerometer"
        case gyro = "Gyro"
    }
    
    struct MotionValue {
        let x: Double
        let y: Double
        let z: Double
        init(x: Double, y: Double, z: Double) {
            self.x = x
            self.y = y
            self.z = z
        }
    }
    
    /// 모션 값 핸들링을 시작합니다. 
    func start(type: MotionType, interval: TimeInterval) {
        motionType = type
        switch type {
        case .gyro:
            manager.startGyroUpdates()
            manager.gyroUpdateInterval = 0.1
            break
        case .acc:
            manager.startAccelerometerUpdates()
            manager.accelerometerUpdateInterval = 0.1
            break
        }
        if delegate.motionValueUpdateWillStart() {
            timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(getMotionValue), userInfo: nil, repeats: true)
        } else {
            //
        }
        
    }
    
    @objc private func getMotionValue() {
        if count == MAX_COUNT {
            cancel()
        }
        switch motionType {
        case .gyro:
            if let gyrodata = manager.gyroData?.rotationRate {
                let data = MotionValue(x: gyrodata.x, y: gyrodata.y, z: gyrodata.z)
                time += timer.timeInterval
                delegate.motionValueDidUpdate(data: data, interval: time)
            }
            else {
                
                // scaling sample for emulator
                var x = 0.0
                var y = 0.0
                var z = 0.0
                
                if count < 70 {
                    x = 100.0
                    z = -100.0
                    y = 0.0
                }
                if count >= 70 && count < 100 {
                    x = 500.0
                    z = -100.0
                    y = 0.0
                }
                
                if count >= 100 {
                    x = 500.0
                    y = 0.0
                    z = -1000.0
                }
                
                var data = MotionValue(x: x, y: y, z: z)
                time += timer.timeInterval
                delegate.motionValueDidUpdate(data: data, interval: time)
            }
            break
        case .acc:
            if let accData = manager.accelerometerData?.acceleration {
                let data = MotionValue(x: accData.x, y: accData.y, z: accData.z)
                time += timer.timeInterval
                delegate.motionValueDidUpdate(data: data, interval: time)
            }
            else {
                
                // scaling sample for emulator
                var x = 0.0
                var y = 0.0
                var z = 0.0
                
                if count < 70 {
                    x = 100.0
                    z = -100.0
                    y = 0.0
                }
                if count >= 70 && count < 100 {
                    x = 500.0
                    z = -100.0
                    y = 0.0
                }
                
                if count >= 100 {
                    x = 500.0
                    y = 0.0
                    z = -1000.0
                }
                
                var data = MotionValue(x: x, y: y, z: z)
                time += timer.timeInterval
                delegate.motionValueDidUpdate(data: data, interval: time)
            }
            break
        case .none:
            break
        }
        count += 1
    }
    
    /// 모션값 핸들링을 중지합니다.
    func cancel() {
        if delegate.motionValueUpdateWillEnd() {
            timer.invalidate()
            isRunning = false
            manager.stopGyroUpdates()
            manager.stopAccelerometerUpdates()
            delegate.motionValueUpdateDidEnd(interval: time)
        }
    }
}


