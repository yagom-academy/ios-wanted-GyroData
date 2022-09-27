//
//  CoreMotionService.swift
//  GyroData
//
//  Created by 신병기 on 2022/09/25.
//

import Foundation
import CoreMotion

class CoreMotionService {
    private let manager = CMMotionManager()
    private let interval = 0.1
    private var timer: Timer?
    private var completion: (() -> Void)? = nil
    private var resultCompletion: ((MotionDetailData) -> Void)? = nil
    
    var motionData: GyroData?
    
    // MARK: - startMotion
    func startMeasurement(of type: MotionType, completion: @escaping () -> Void, resultCompletion: @escaping (MotionDetailData) -> Void) {
        motionData = GyroData(date: Date(), type: type)
        self.completion = completion
        self.resultCompletion = resultCompletion
        completion()
        
        switch type {
        case .acc:  startAccelerometers()
        case .gyro: startGyros()
        }
    }

    private func startAccelerometers() {
        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = interval
            manager.startAccelerometerUpdates()
            
            var timeout = 0

            timer = Timer(timeInterval: interval, repeats: true, block: { timer in
                guard timeout < 600 else {
                    self.stopMeasurement(of: .acc)
                    return
                }
                timeout += 1
                
                if let data = self.manager.accelerometerData {
                    let x = data.acceleration.x
                    let y = data.acceleration.y
                    let z = data.acceleration.z
                    let tick = Double(timeout) * self.interval
                    self.resultCompletion?(MotionDetailData(tick: tick, x: x, y: y, z: z))
                    self.appendItem(tick, x, y, z)
                }
            })
            
            if let timer = timer {
                RunLoop.current.add(timer, forMode: .default)
            }
        }
    }
    
    private func startGyros() {
        if manager.isGyroAvailable {
            manager.gyroUpdateInterval = interval
            manager.startGyroUpdates()
            
            var timeout = 0

            self.timer = Timer(timeInterval: interval, repeats: true, block: { timer in
                guard timeout < 600 else {
                    self.stopMeasurement(of: .gyro)
                    return
                }
                timeout += 1
                
                if let data = self.manager.gyroData {
                    let x = data.rotationRate.x
                    let y = data.rotationRate.y
                    let z = data.rotationRate.z
        
                    let tick = Double(timeout) * self.interval
                    self.resultCompletion?(MotionDetailData(tick: tick, x: x, y: y, z: z))
                    self.appendItem(tick, x, y, z)
                }
            })
            
            if let timer = self.timer {
                RunLoop.current.add(timer, forMode: .default)
            }
        }
    }

    private func appendItem(_ tick: Double, _ x: Double, _ y: Double, _ z: Double) {
        let digit: Double = 10
        let truncTick = trunc(tick * digit) / digit
        let item = MotionDetailData(tick: truncTick, x: x, y: y, z: z)
        self.motionData?.items.append(item)
        dump(self.motionData!)
    }

    func stopMeasurement(of type: MotionType) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
            
            switch type {
            case .acc: manager.stopAccelerometerUpdates()
            case .gyro: manager.stopGyroUpdates()
            }
        }
        completion?()
    }
}
