//
//  MeasureViewModel.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/03.
//

import Foundation

final class MeasureViewModel {
    enum Action {
        case motionTypeChange(with: String?)
        case measure
        case stop
        case save(handler: () -> Void)
    }
    
    private lazy var motionManager: MotionManagerable = AccelerometerMotionManager(
        deadline: 60,
        interval: 0.1
    )
    
    private var motionCoordinate: MotionCoordinate? {
        didSet {
            guard let motionCoordinate = motionCoordinate else { return }
            motionCoordinateHandler?(motionCoordinate)
        }
    }
    
    private var canChangeMotionType: Bool = true {
        didSet {
            canChangeMotionTypeHandler?(canChangeMotionType)
        }
    }
    
    private var canStopMeasure: Bool = false {
        didSet {
            canStopMeasureHandler?(canStopMeasure)
        }
    }
    
    private var canSaveMeasureData: Bool = false {
        didSet {
            canSaveMeasureDataHandler?(canSaveMeasureData)
        }
    }
    
    private var alertMessage: String? {
        didSet {
            alertMessageHandler?(alertMessage)
        }
    }
    
    private var motionCoordinateHandler: ((MotionCoordinate) -> Void)?
    private var canChangeMotionTypeHandler: ((Bool) -> Void)?
    private var canStopMeasureHandler: ((Bool) -> Void)?
    private var canSaveMeasureDataHandler: ((Bool) -> Void)?
    private var alertMessageHandler: ((String?) -> Void)?
    
    func action(_ action: Action) {
        switch action {
        case .motionTypeChange(let type):
            verifyMotionType(with: type)
        case .measure:
            startMeasure()
        case .stop:
            stopMeasure()
        case .save(let handler):
            save(handler: handler)
        }
    }
}

// MARK: Business Logic
extension MeasureViewModel {
    private func verifyMotionType(with type: String?) {
        guard let type = type,
              let motionType = MotionType(rawValue: type)
        else {
            return
        }
        
        changeMotionManager(with: motionType)
    }
    
    private func changeMotionManager(with motionType: MotionType) {
        switch motionType {
        case .accelerometer:
            motionManager = AccelerometerMotionManager(
                deadline: 60,
                interval: 0.1
            )
        case .gyroscope:
            motionManager = GyroMotionManager(
                deadline: 60,
                interval: 0.1
            )
        }
    }
    
    private func startMeasure() {
        canChangeMotionType = false
        canStopMeasure = true
        canSaveMeasureData = false
        
        motionManager.timeOverHandler = { [weak self] isTimeOver in
            self?.canSaveMeasureData = isTimeOver
            self?.canStopMeasure = !isTimeOver
        }
        
        motionManager.start { [weak self] motionCoordinate in
            self?.motionCoordinate = motionCoordinate
        }
    }
    
    private func stopMeasure() {
        canChangeMotionType = true
        canStopMeasure = false
        canSaveMeasureData = true
        
        motionManager.stop()
    }
    
    private func save(handler: @escaping () -> Void) {
        motionManager.save(completionHandler: handler) { [weak self] error in
            self?.alertMessage = error.localizedDescription
        }
    }
}

// MARK: Bind Method
extension MeasureViewModel {
    func bindCanChangeMotionType(handler: @escaping (Bool) -> Void) {
        canChangeMotionTypeHandler = handler
    }
    
    func bindCanStopMeasure(handler: @escaping (Bool) -> Void) {
        canStopMeasureHandler = handler
    }
    
    func bindCanSaveMeasureData(handler: @escaping (Bool) -> Void) {
        canSaveMeasureDataHandler = handler
    }
    
    func bindAlertMessage(handler: @escaping (String?) -> Void) {
        alertMessageHandler = handler
    }
    
    func bindMotionCoordinate(handler: @escaping (MotionCoordinate) -> Void) {
        motionCoordinateHandler = handler
    }
}
