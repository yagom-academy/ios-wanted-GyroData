//
//  CoreMotionRepository.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import CoreMotion

protocol CoreMotionRepositorable {
    func startAccelerometer(_ completion: @escaping (MotionCoordinates) -> Void)
    func startGyroscope(completion: @escaping (MotionCoordinates) -> Void)
    func stopAccelerometer()
    func stopGyroscope()
}

final class CoreMotionRepository: CoreMotionRepositorable {
    
    let dataSource: CoreMotionManager
    
    init(dataSource: CoreMotionManager) {
        self.dataSource = dataSource
    }
    
    func startAccelerometer(_ completion: @escaping (MotionCoordinates) -> Void) {
        if dataSource.motionManager.isAccelerometerAvailable {
            dataSource.motionManager.startAccelerometerUpdates(
                to: dataSource.backgroundOperationQueue) {
                    data, error in
                    guard let data = data?.acceleration else { return }
                    let accelerationCoordinates = MotionCoordinates(
                        x: data.x,
                        y: data.y,
                        z: data.z
                    )
                    print("repository received ----------")
                    completion(accelerationCoordinates)
                }
        }
    }
    
    func startGyroscope(completion: @escaping (MotionCoordinates) -> Void) {
        if dataSource.motionManager.isGyroAvailable {
            dataSource.motionManager.startGyroUpdates(
                to: dataSource.backgroundOperationQueue) {
                    data, error in
                    guard let data = data?.rotationRate else { return }
                    let gyroCoordinates = MotionCoordinates(
                        x: data.x,
                        y: data.y,
                        z: data.z
                    )
                    print("repository received ----------")
                    completion(gyroCoordinates)
                }
        }
    }
    
    func stopAccelerometer() {
        dataSource.motionManager.stopAccelerometerUpdates()
    }
    
    func stopGyroscope() {
        dataSource.motionManager.stopGyroUpdates()
    }
}
