//
//  GyroRecorder.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import CoreMotion
import Combine

final class GyroRecorder {
    enum Constant {
        static let frequency = 10.0
    }
    
    static let shared = GyroRecorder()
    private let motionManager = CMMotionManager()
    private var dataType: GyroData.DataType?
    @Published private var gyroData: GyroData?
    
    private init() {
        setupPeriod()
    }
    
    func gyroDataPublisher() -> AnyPublisher<GyroData?, Never> {
        return $gyroData
            .eraseToAnyPublisher()
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
    
    func stop() {
        guard let dataType else { return }
        
        switch dataType {
        case .accelerometer:
            stopAccelerometerUpdates()
        case .gyro:
            stopGyroUpdates()
        }
    }
    
    func clear() {
        dataType = nil
        gyroData = nil
    }
    
    private func startAccelerometerUpdates() {
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
    
    private func stopAccelerometerUpdates() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    private func stopGyroUpdates() {
        if motionManager.isGyroActive {
            motionManager.stopGyroUpdates()
        }
    }
    
    private func setupPeriod() {
        let period = 1 / GyroRecorder.Constant.frequency
        
        motionManager.accelerometerUpdateInterval = period
        motionManager.gyroUpdateInterval = period
    }
}
