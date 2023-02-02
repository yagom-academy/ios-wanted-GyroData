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
    private weak var delegate: MotionMeasurementViewModelDelegate?
    
    init(createService: MotionCreatable, delegate: MotionMeasurementViewModelDelegate? = nil) {
        self.createService = createService
        self.delegate = delegate
    }
    
    func action(_ action: Action) {
        switch action {
        case let .measurementStart(type):
            break
        case let .measurementStop(type):
            break
        case let .motionCreate(date, type, time, data):
            break
        }
    }
}
