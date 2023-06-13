//
//  MeasureViewModel.swift
//  GyroData
//
//  Created by 리지 on 2023/06/13.
//

import Combine
import CoreMotion

final class MeasureViewModel {
    var accelerometerSubject = PassthroughSubject<[ThreeAxisValue], Never>()
    var gyroscopeSubject = PassthroughSubject<[ThreeAxisValue], Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private let motionManager = CMMotionManager()
    private var timer: Timer?
    
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

    private func acceleroDataPublisher() -> Future<[ThreeAxisValue], Error> {
        return Future<[ThreeAxisValue], Error> { promise in
            
            let timeout: TimeInterval = 5
            var accelerometerData: [ThreeAxisValue] = []
            var elapsedTime: TimeInterval = 0
            
            self.motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = data {
                    
                    let accX = data.acceleration.x
                    let accY = data.acceleration.y
                    let accZ = data.acceleration.z
                    let accData = ThreeAxisValue(valueX: accX, valueY: accY, valueZ: accZ)
                    accelerometerData.append(accData)
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
    
    private func gyroDataPublisher() -> Future<[ThreeAxisValue], Error> {
        return Future<[ThreeAxisValue], Error> { promise in
            
            let timeout: TimeInterval = 5
            var gyroscopeData: [ThreeAxisValue] = []
            var elapsedTime: TimeInterval = 0
            
            self.motionManager.startGyroUpdates(to: .main) { [weak self] data, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = data {
                    
                    let gyroX = data.rotationRate.x
                    let gyroY = data.rotationRate.y
                    let gyroZ = data.rotationRate.z
                    let gyroData = ThreeAxisValue(valueX: gyroX, valueY: gyroY, valueZ: gyroZ)
                    gyroscopeData.append(gyroData)
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

extension MeasureViewModel {
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
    
    func stopMeasure(by selectedSensor: SensorType) {
        timer?.invalidate()
        switch selectedSensor {
        case .accelerometer:
            motionManager.stopAccelerometerUpdates()
        case .gyroscope:
            motionManager.stopGyroUpdates()
        }
    }
    
    func saveToFileManager(_ data: SixAxisData) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(data)
            
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("SixAxisData.json")
                try jsonData.write(to: fileURL)
            }
        } catch {
            print("JSON Encoding Fail \(error)")
        }
    }
}
