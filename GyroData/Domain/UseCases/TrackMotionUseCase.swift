//
//  CoreMotionUseCase.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

protocol TrackMotionUseCaseType {
    func startAccelerometer(_ completion: @escaping (MotionCoordinates) -> Void)
    func startGyro(_ completion: @escaping (MotionCoordinates) -> Void)
    func stopAccelerometer()
    func stopGyro()
}

final class TrackMotionUseCase: TrackMotionUseCaseType {
    let repository: CoreMotionRepositorable
    
    init(repository: CoreMotionRepository) {
        self.repository = repository
    }
    
    func startAccelerometer(_ completion: @escaping (MotionCoordinates) -> Void) {
        repository.startAccelerometer { data in
            completion(data)
        }
        print("Accel")
    }
    
    func startGyro(_ completion: @escaping (MotionCoordinates) -> Void) {
        repository.startGyroscope { data in
            completion(data)
        }
        print("Gyro")
    }
    
    func stopAccelerometer() {
        repository.stopAccelerometer()
    }
    
    func stopGyro() {
        repository.stopGyroscope()
    }
}
