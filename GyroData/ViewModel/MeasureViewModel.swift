//
//  MeasureViewModel.swift
//  GyroData
//
//  Created by 리지 on 2023/06/13.
//

import Combine
import CoreMotion

final class MeasureViewModel {
    var accelerometerSubject = PassthroughSubject<[(x: Double, y: Double, z: Double)], Never>()
    var gyroscopeSubject = PassthroughSubject<[(x: Double, y: Double, z: Double)], Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private let motionManager = CMMotionManager()
    private var timer: Timer?
    
    func startMeasure(by selectedSensor: SensorType) {
        let updateInterval = 0.1
        switch selectedSensor {
        case .accelerometer:
            timer = Timer(timeInterval: updateInterval,
                          target: self,
                          selector: #selector(measureAcc),
                          userInfo: nil,
                          repeats: true)
        case .gyroscope:
            timer = Timer(timeInterval: updateInterval,
                          target: self,
                          selector: #selector(measureGyro),
                          userInfo: nil,
                          repeats: true)
        }
        
        timer?.fire()
    }
    
    func stopMeasure() {
        timer?.invalidate()
    }
    
    @objc private func measureAcc(timer: Timer) {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            acceleroDataPublisher()
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] gyroscope in
                    self?.accelerometerSubject.send(gyroscope)
                }
                .store(in: &cancellables)
           }
    }
    
    @objc private func measureGyro(timer: Timer) {
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            gyroDataPublisher()
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] gyroscope in
                    self?.gyroscopeSubject.send(gyroscope)
                }
                .store(in: &cancellables)
        }
    }

    private func acceleroDataPublisher() -> Future<[(x: Double, y: Double, z: Double)], Error> {
        return Future<[(x: Double, y: Double, z: Double)], Error> { promise in
            
            let timeout: TimeInterval = 60
            var accelerometerData: [(x: Double, y: Double, z: Double)] = []
            var elapsedTime: TimeInterval = 0
            
            self.motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = data {
                    
                    let accX = data.acceleration.x
                    let accY = data.acceleration.y
                    let accZ = data.acceleration.z
                    accelerometerData.append((x: accX, y: accY, z: accZ))
                    print("acc측정 중")
                    elapsedTime += 0.1
                    
                    if elapsedTime >= timeout {
                        self?.motionManager.stopAccelerometerUpdates()
                        self?.timer?.invalidate()
                        promise(.success(accelerometerData))
                    }
                }
            }
        }
    }
    
    private func gyroDataPublisher() -> Future<[(x: Double, y: Double, z: Double)], Error> {
        return Future<[(x: Double, y: Double, z: Double)], Error> { promise in
            
            let timeout: TimeInterval = 60
            var gyroscopeData: [(x: Double, y: Double, z: Double)] = []
            var elapsedTime: TimeInterval = 0
            
            self.motionManager.startGyroUpdates(to: .main) { [weak self] data, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = data {
                    let gyroX = data.rotationRate.x
                    let gyroY = data.rotationRate.y
                    let gyroZ = data.rotationRate.z
                    gyroscopeData.append((x: gyroX, y: gyroY, z: gyroZ))
                    print("gyro측정 중")
                    elapsedTime += 0.1
                    
                    if elapsedTime >= timeout {
                        self?.motionManager.stopGyroUpdates()
                        self?.timer?.invalidate()
                        promise(.success(gyroscopeData))
                    }
                }
            }
        }
    }
}
