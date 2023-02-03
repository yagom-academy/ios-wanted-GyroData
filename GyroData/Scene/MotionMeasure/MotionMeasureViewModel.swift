//
//  MotionMeasureViewModel.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol MotionMeasurementViewModelDelegate: AnyObject {
    func motionMeasurementViewModel(measuredData data: MotionDataType, takenCurrentTime time: Double)
    func motionMeasurementViewModel(isCompletedInMotionMeasurement: Bool)
    func motionMeasurementViewModel(isSucceedInCreating: Bool)
    func motionMeasurementViewModel(alertStyleToPresent: AlertStyle)
}

final class MotionMeasurementViewModel {
    enum Action {
        case measurementStart(type: Int)
        case measurementStop(type: Int)
        case motionCreate(date: String, type: Int, time: String, data: [MotionDataType])
    }

    private let createService: MotionCreatable
    private let measurementService: MotionMeasurable
    private weak var delegate: MotionMeasurementViewModelDelegate?
    
    init(
        createService: MotionCreatable,
        measurementService: MotionMeasurable
    ) {
        self.createService = createService
        self.measurementService = measurementService
    }
    
    func action(_ action: Action) {
        switch action {
        case let .measurementStart(type):
            guard let type = Motion.MeasurementType(rawValue: type) else { return }
            startMeasurementService(of: type)
        case let .measurementStop(type):
            guard let type = Motion.MeasurementType(rawValue: type) else { return }
            measurementService.stopMeasurement(type: type)
        case let .motionCreate(date, type, time, data):
            createMotionWith(date: date, type: type, time: time, data: data)
        }
    }
    
    func configureDelegate(_ delegate: MotionMeasurementViewModelDelegate) {
        self.delegate = delegate
    }
}

private extension MotionMeasurementViewModel {
    func startMeasurementService(of type: Motion.MeasurementType) {
        measurementService.measure(
            type: type,
            measurementHandler: { [weak self] data, time in
                self?.delegate?.motionMeasurementViewModel(measuredData: data, takenCurrentTime: time)
            }, completeHandler: { [weak self] isCompleted in
                self?.delegate?.motionMeasurementViewModel(isCompletedInMotionMeasurement: true)
            })
    }
    
    func createMotionWith(date: String, type: Int, time: String, data: [MotionDataType]) {
        createService.create(
            date: date,
            type: type,
            time: time,
            data: data
        ) { [weak self] isSuccess in
            if isSuccess {
                self?.delegate?.motionMeasurementViewModel(isSucceedInCreating: isSuccess)
            } else {
                self?.delegate?.motionMeasurementViewModel(alertStyleToPresent: .motionCreatingFailed)
            }
        }
    }
}
