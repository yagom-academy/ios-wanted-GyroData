//
//  GyroRecorder.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import CoreMotion

final class GyroRecorder {
    enum Constant {
        static let frequency = 10.0
    }
    
    static let shared = GyroRecorder()
    private let motionManager = CMMotionManager()
    private var dataType: GyroData.DataType?
    private var gyroData: GyroData?
    
    private init() {
        setupPeriod()
    }
    
    func start(dataType: GyroData.DataType) {
        self.dataType = dataType
        gyroData = GyroData(dataType: dataType)
        
        switch dataType {
        case .accelerometer:
            startAccelerometerUpdates()
        case .gyro:
            startGyroUpdates()
        }
    }
    
    private func startAccelerometerUpdates() {
        motionManager.accelerometerUpdateInterval = 0.1
        
        motionManager.startAccelerometerUpdates(to: .current!) { [weak self] data, error in
            guard let x = data?.acceleration.x,
                  let y = data?.acceleration.y,
                  let z = data?.acceleration.z else {
                // error handle
                return
            }
            
            let data = Coordinate(x: x, y: y, z: z)
            self?.gyroData?.add(data)
        }
    }
    
    private func startGyroUpdates() {
        motionManager.gyroUpdateInterval = 0.1
        
        motionManager.startGyroUpdates(to: .current!) { [weak self] data, error in
            guard let x = data?.rotationRate.x,
                  let y = data?.rotationRate.y,
                  let z = data?.rotationRate.z else {
                // error handle
                return
            }
            
            let data = Coordinate(x: x, y: y, z: z)
            self?.gyroData?.add(data)
        }
    }
    
    private func setupPeriod() {
        let period = 1 / GyroRecorder.Constant.frequency
        
        motionManager.accelerometerUpdateInterval = period
        motionManager.gyroUpdateInterval = period
    }
}
