//
//  MotionRecordingViewModel.swift
//  GyroData
//
//  Created by YunYoungseo on 2022/12/28.
//

import Foundation
import CoreMotion

final class MotionRecordingViewModel {
    var motionMode: MotionMode {
        didSet {
            coordinates.removeAll()
        }
    }
    var isRecording: Bool = false {
        didSet {
            reflectRecordingState?(isRecording)
        }
    }
    var isFullDatas: Bool {
        let maximumCount = Int(self.timeOut / self.updateTimeInterval)
        return self.coordinates.count >= maximumCount
    }
    var isSaveEnable: Bool {
        let isEmpty = coordinates.isEmpty
        return !(isEmpty || isRecording)
    }
    var reflectRecordingState: ((Bool) -> Void)?
    var saveRecordingCompletion: ((Result<Void, Error>) -> Void)?
    private let saveMotionDataUseCase = SaveMotionDataUseCase()
    private let timeOut = TimeInterval(60)
    private var startDate = Date()
    private var motionManager = CMMotionManager()
    private var coordinates = [Coordinate]()
    private let updateTimeInterval: TimeInterval = 0.1
    private var updateCompletion: (Coordinate) -> Void

    init(motionMode: MotionMode, updateCompletion: @escaping (Coordinate) -> Void) {
        self.motionMode = motionMode
        self.updateCompletion = updateCompletion
        motionManager.accelerometerUpdateInterval = updateTimeInterval
        motionManager.gyroUpdateInterval = updateTimeInterval
    }

    func saveRecord() {
        let motionRecord = MotionRecord(
            id: UUID(),
            startDate: startDate,
            motionMode: motionMode,
            coordinates: coordinates
        )
        saveMotionDataUseCase.excute(record: motionRecord) { [weak self] result in
            self?.saveRecordingCompletion?(result)
        }
    }

    func startRecording() {
        isRecording = true

        let updateHandler: (Coordinate) -> Void = { [weak self] newData in
            guard let self = self else { return }
            if self.isFullDatas {
                self.coordinates.removeAll()
            }
            self.coordinates.append(newData)
            self.updateCompletion(newData)
            guard !self.isFullDatas else {
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
                let newCoordinate = Coordinate(newData)
                updateHandler(newCoordinate)
            }
            motionManager.startAccelerometerUpdates(to: OperationQueue(), withHandler: accelerometerHandler)
        case .gyroscope:
            let gyroHandler: CMGyroHandler = { [weak self] newData, error in
                guard let newData = newData?.rotationRate else {
                    self?.stopRecording()
                    return
                }
                let newCoordinate = Coordinate(newData)
                updateHandler(newCoordinate)
            }
            motionManager.startGyroUpdates(to: OperationQueue(), withHandler: gyroHandler)
        }
    }

    func stopButtonTapped() {
        stopRecording()
    }

    private func stopRecording() {
        isRecording = false
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
    }

    func initializeModel() {
        startDate = Date()
        coordinates.removeAll()
    }
}

private extension Coordinate {
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
