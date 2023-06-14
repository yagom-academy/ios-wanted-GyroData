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
        static let timeout = 60.0
    }
    
    static let shared = GyroRecorder()
    private let motionManager = CMMotionManager()
    private var dataType: GyroData.DataType?
    @Published private var gyroData: GyroData?
    @Published private(set) var isUpdating: Bool = false
    
    private init() {
        setupInterval()
    }
    
    func gyroDataPublisher() -> AnyPublisher<GyroData?, Never> {
        return $gyroData
            .eraseToAnyPublisher()
    }
    
    func start(dataType: GyroData.DataType) {
        self.dataType = dataType
        gyroData = GyroData(dataType: dataType)
        gyroData?.duration = 0.0
        
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
    
    func getGyroData() -> GyroData? {
        return gyroData
    }
    
    func clear() {
        dataType = nil
        gyroData = nil
    }
    
    private func startAccelerometerUpdates() {
        guard let queue = OperationQueue.current else { return }
        
        isUpdating = true
        let interval = motionManager.accelerometerUpdateInterval
        
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] data, error in
            guard let duration = self?.gyroData?.duration,
                  duration < GyroRecorder.Constant.timeout else {
                // time out handle
                self?.stopAccelerometerUpdates()
                
                return
            }
            
            guard let x = data?.acceleration.x,
                  let y = data?.acceleration.y,
                  let z = data?.acceleration.z else {
                // error handle
                return
            }
            
            let data = Coordinate(x: x, y: y, z: z)
            self?.gyroData?.add(data, interval: interval)
        }
    }
    
    private func startGyroUpdates() {
        guard let queue = OperationQueue.current else { return }
        
        isUpdating = true
        let interval = motionManager.gyroUpdateInterval
        
        motionManager.startGyroUpdates(to: queue) { [weak self] data, error in
            guard let duration = self?.gyroData?.duration,
                  duration < GyroRecorder.Constant.timeout else {
                // time out handle
                self?.stopGyroUpdates()
                
                return
            }
            
            guard let x = data?.rotationRate.x,
                  let y = data?.rotationRate.y,
                  let z = data?.rotationRate.z else {
                // error handle
                return
            }
            
            let data = Coordinate(x: x, y: y, z: z)
            self?.gyroData?.add(data, interval: interval)
        }
    }
    
    private func stopAccelerometerUpdates() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
            isUpdating = false
        }
    }
    
    private func stopGyroUpdates() {
        if motionManager.isGyroActive {
            motionManager.stopGyroUpdates()
            isUpdating = false
        }
    }
    
    private func setupInterval() {
        let interval = 1 / GyroRecorder.Constant.frequency
        
        motionManager.accelerometerUpdateInterval = interval
        motionManager.gyroUpdateInterval = interval
    }
}
