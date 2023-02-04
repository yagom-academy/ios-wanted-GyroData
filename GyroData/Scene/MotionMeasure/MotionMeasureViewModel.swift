//
//  MotionMeasureViewModel.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

protocol MotionMeasurementViewModelDelegate: AnyObject {
    func motionMeasurementViewModel(measuredData data: MotionDataType)
    func motionMeasurementViewModel(actionConfigurationAboutMeasurementStarted: Void)
    func motionMeasurementViewModel(actionConfigurationAboutMeasurementCompleted: Void)
    func motionMeasurementViewModel(actionConfigurationAboutInsufficientData: Void)
    func motionMeasurementViewModel(actionConfigurationAboutCreatingSuccess: Void)
    func motionMeasurementViewModel(actionConfigurationAboutCreatingFailed: Void)
}

final class MotionMeasurementViewModel {
    enum Constant {
        static let dateFormat = "yyyy/MM/dd HH:mm:ss"
    }
    enum Action {
        case measurementStart(type: Int)
        case measurementStop(type: Int)
        case motionCreate(type: Int, time: String, data: [MotionDataType])
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
            delegate?.motionMeasurementViewModel(actionConfigurationAboutMeasurementStarted: ())
        case let .measurementStop(type):
            guard let type = Motion.MeasurementType(rawValue: type) else { return }
            measurementService.stopMeasurement(type: type)
            delegate?.motionMeasurementViewModel(actionConfigurationAboutMeasurementCompleted: ())
        case let .motionCreate(type, time, data):
            createMotionWith(type: type, time: time, data: data)
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
            measurementHandler: { [weak self] data in
                self?.delegate?.motionMeasurementViewModel(measuredData: data)
            },
            completeHandler: { [weak self] isCompleted in
                if isCompleted {
                    self?.delegate?.motionMeasurementViewModel(
                        actionConfigurationAboutMeasurementCompleted: ()
                    )
                }
            })
    }
    
    func createMotionWith(type: Int, time: String, data: [MotionDataType]) {
        createService.create(
            date: Date().formatted(by: Constant.dateFormat),
            type: type,
            time: time,
            data: data
        ) { [weak self] result in
            switch result {
            case .success():
                self?.delegate?.motionMeasurementViewModel(actionConfigurationAboutCreatingSuccess: ())
            case .failure(let error) where error == .motionCreatingFailed:
                DispatchQueue.main.async {
                    self?.delegate?.motionMeasurementViewModel(
                        actionConfigurationAboutCreatingFailed: ()
                    )
                }
            case .failure(let error) where error == .insufficientDataToCreate:
                DispatchQueue.main.async {
                    self?.delegate?.motionMeasurementViewModel(
                        actionConfigurationAboutInsufficientData: ()
                    )
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.delegate?.motionMeasurementViewModel(
                        actionConfigurationAboutCreatingFailed: ()
                    )
                }
            }
        }
    }
}
