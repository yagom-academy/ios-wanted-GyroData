//
//  MotionManager.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/27.
//

import CoreMotion

final class MotionManager {
    
    // MARK: Properties
    
    private let createDate = Date().timeIntervalSince1970
    private let dataManager = MotionDataManager.shared
    private let motionManager = CMMotionManager()
    
    // MARK: - Initializers
    
    init() {
        commonInit()
    }
    
    // MARK: - Methods
    
//    func startUpdates() {
//        switch motionType {
//        case .accelerometer:
//            startAccelerometerRecord()
//        case .gyro:
//            startGyroRecord()
//        }
//    }
    
//    func stopUpdates() {
//        switch motionType {
//        case .accelerometer:
//            motionManager.stopAccelerometerUpdates()
//        case .gyro:
//            motionManager.stopGyroUpdates()
//        }
//    }
    
    private func commonInit() {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
    }
    
    private func convertGyroData(data: Double?) -> [Double] {
        guard let unwrapData = data else { return [0.0] }
        return [unwrapData]
    }
    
    private func makeGyroCoordinate(coordinateX: [Double], coordinateY: [Double],
                                coordinateZ:[Double]) -> [[Double]] {
        
        var coordinateArray = [[Double]]()
        for count in 0..<coordinateX.count {
            let coordinate = [coordinateX[count], coordinateY[count], coordinateZ[count]]
            coordinateArray.append(coordinate)
        }
        
        return coordinateArray
    }
    
    func startAccelerometerRecord() {
        var maxCount = 60
        motionManager.startAccelerometerUpdates(
            to: .main
        ) { [weak self] data, error in
            guard let self = self else { return }
            
            let coordinateModel = self.makeGyroCoordinate(
                                        coordinateX: self.convertGyroData(data: data?.acceleration.x),
                                        coordinateY: self.convertGyroData(data: data?.acceleration.y),
                                        coordinateZ: self.convertGyroData(data: data?.acceleration.z))
            
            let accModel = GyroModel(id: UUID(),
                                      coordinate: coordinateModel,
                                      createdAt: self.createDate,
                                      motionType: MotionType.accelerometer.codeName)
            
            self.dataManager.saveMotion(data: accModel)
        }
        let timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { timer in
            if maxCount == 0 {
                self.motionManager.stopAccelerometerUpdates()
                timer.invalidate()
            }
 
            maxCount -= 1
        }
    }
    
    func startGyroRecord() {
        var maxCount = 60
        motionManager.startGyroUpdates(
            to: .main
        ) { [weak self] data, error in
            guard let self = self else { return }
            let coordinateModel = self.makeGyroCoordinate(
                                        coordinateX: self.convertGyroData(data: data?.rotationRate.x),
                                        coordinateY: self.convertGyroData(data: data?.rotationRate.y),
                                        coordinateZ: self.convertGyroData(data: data?.rotationRate.z))
            
            let gyroModel = GyroModel(id: UUID(),
                                      coordinate: coordinateModel,
                                      createdAt: self.createDate,
                                      motionType: MotionType.accelerometer.codeName)
            
            self.dataManager.saveMotion(data: gyroModel)
        }
        let timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { timer in
            if maxCount == 0 {
                self.motionManager.stopGyroUpdates()
                timer.invalidate()
            }
 
            maxCount -= 1
        }
    }
}
