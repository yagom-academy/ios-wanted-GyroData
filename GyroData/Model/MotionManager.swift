//
//  MotionManager.swift
//  GyroData
//
//  Created by junho, summercat on 2023/01/31.
//

import Foundation
import CoreMotion

final class MotionManager: MotionManagerType {
    enum Constant {
        enum Namespace {
            static let updateInterval: Double = 1.0 / 10.0
            static let maxLength: Double = 60.0
        }
    }
    
    private let motion: CMMotionManager = CMMotionManager()
    private var timer: Timer = Timer()
    
    // TODO: - "측정"의 의미를 담아 rename
    func startAccelerometer(_ closure: @escaping (Coordinate) -> Void) {
        guard motion.isAccelerometerAvailable else { return }
        motion.showsDeviceMovementDisplay = true
        motion.accelerometerUpdateInterval = Constant.Namespace.updateInterval
        motion.startAccelerometerUpdates()
        
        let startTime = Date()
        
        timer = Timer(
            fire: Date(),
            interval: Constant.Namespace.updateInterval,
            repeats: true
        ) { _ in
            let timeInterval = Date().timeIntervalSince(startTime)
            guard timeInterval <= Constant.Namespace.maxLength else {
                self.stopAccelerometer()
                return
            }
            if let data = self.motion.deviceMotion {
                let coordinate = Coordinate(data.userAcceleration)
                // 이 클로저는 백그라운드 큐에서 돌아가게 된다.
                // TODO: - 그래프 그리는 부분(UI업데이트)는 메인 큐에서 돌아갈 수 있도록 메인큐로 보내주는 작업이 필요하다.
                closure(coordinate)
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            let runLoop = RunLoop.current
            runLoop.add(self.timer, forMode: .default)
            runLoop.run()
        }
    }
    
    func stopAccelerometer() {
        timer.invalidate()
        motion.stopAccelerometerUpdates()
    }
    
    func startGyro(_ closure: @escaping (Coordinate) -> Void) {
        guard motion.isGyroAvailable else { return }
        motion.showsDeviceMovementDisplay = true
        motion.gyroUpdateInterval = Constant.Namespace.updateInterval
        motion.startGyroUpdates()
        
        let startTime = Date()
        
        timer = Timer(
            fire: Date(),
            interval: Constant.Namespace.updateInterval,
            repeats: true
        ) { _ in
            let timeInterval = Date().timeIntervalSince(startTime)
            guard timeInterval <= Constant.Namespace.maxLength else {
                self.stopAccelerometer()
                return
            }
            if let data = self.motion.deviceMotion {
                let coordinate = Coordinate(data.rotationRate)
                // 이 클로저는 백그라운드 큐에서 돌아가게 된다.
                // TODO: - 그래프 그리는 부분(UI업데이트)는 메인 큐에서 돌아갈 수 있도록 메인큐로 보내주는 작업이 필요하다.
                closure(coordinate)
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            let runLoop = RunLoop.current
            runLoop.add(self.timer, forMode: .default)
            runLoop.run()
        }
    }
    
    func stopGyro() {
        timer.invalidate()
        motion.stopGyroUpdates()
    }
}
