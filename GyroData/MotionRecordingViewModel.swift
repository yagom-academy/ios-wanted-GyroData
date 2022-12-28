//
//  MotionRecordingViewModel.swift
//  GyroData
//
//  Created by YunYoungseo on 2022/12/28.
//

import Foundation
import CoreMotion

final class MotionRecordingViewModel {
    private let id = UUID()
    private let timeOut = TimeInterval(60)
    private let motionMode: MotionMode
    private var startDate = Date()
    private var motionManager = CMMotionManager()
    private var coordinates = [Coordiante]()
    private var timer: Timer?
    private var updateTimeInterval: TimeInterval {
        didSet {
            motionManager.accelerometerUpdateInterval = updateTimeInterval
            motionManager.gyroUpdateInterval = updateTimeInterval
        }
    }

    init(msInterval: Int, motionMode: MotionMode) {
        self.motionMode = motionMode
        updateTimeInterval = Double(msInterval) / 1000
    }

    // TODO: Error 처리
    func startRecording() {
        startDate = Date()
        let updateHandler: (Coordiante) -> Void = { [weak self] newData in
            guard let self = self else {
                return
            }
            self.coordinates.append(newData)

            var isFullDatas: Bool {
                let maximumCount = Int(self.timeOut / self.updateTimeInterval)
                return self.coordinates.count >= maximumCount
            }
            guard isFullDatas == false else {
                self.stopRecording()
                return
            }
        }

        switch motionMode {
        case .accelerometer:
            let accelerometerHandler: CMAccelerometerHandler = { [weak self] newData, error in
                guard let newData = newData?.acceleration else {
                    self?.stopRecording()
                    return
                }
                let newCoordinate = Coordiante(newData)
                updateHandler(newCoordinate)
            }
            motionManager.startAccelerometerUpdates(to: OperationQueue(), withHandler: accelerometerHandler)
        case .gyroscope:
            let gyroHandler: CMGyroHandler = { [weak self] newData, error in
                guard let newData = newData?.rotationRate else {
                    self?.stopRecording()
                    return
                }
                let newCoordinate = Coordiante(newData)
                self?.coordinates.append(newCoordinate)
            }
            motionManager.startGyroUpdates(to: OperationQueue(), withHandler: gyroHandler)
        }
        timer = Timer(timeInterval: 60, repeats: false) { [weak self] _ in
            self?.stopRecording()
        }
    }

    func stopRecording() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
    }
}

private extension Coordiante {
    init(_ data: CMAcceleration) {
        self.x = data.x
        self.y = data.y
        self.z = data.z
    }

    init(_ data: CMRotationRate) {
        self.x = data.x
        self.y = data.y
        self.z = data.z
    }
}
