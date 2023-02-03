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
        case save
    }
    
    private var motionManager: MotionManagerable = AccelerometerMotionManager(
        duration: 60,
        interval: 0.1
    )
    
    private var measuredMotion: MotionMeasures? {
        didSet {

        }
    }
    
    private var canChangeMotionType: Bool = true {
        didSet {
            canChangeMotionTypeHandler?(canChangeMotionType)
        }
    }
    
    private var canChangeMotionTypeHandler: ((Bool) -> Void)?
    
    func action(_ action: Action) {
        switch action {
        case .motionTypeChange(let type):
            verifyMotionType(with: type)
        case .measure:
            startMeasure()
        case .stop:
            stopMeasure()
        case .save:
            // TODO: 저장
            break
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
                duration: 60,
                interval: 0.1
            )
        case .gyroscope:
            motionManager = GyroMotionManager(
                duration: 60,
                interval: 0.1
            )
        }
    }
    
    private func startMeasure() {
        canChangeMotionType = false
        measuredMotion =  MotionMeasures(
            axisX: [],
            axisY: [],
            axisZ: []
        )
        
        motionManager.start { [weak self] measuredCoordinate in
            self?.measuredMotion?.axisX.append(measuredCoordinate.x)
            self?.measuredMotion?.axisY.append(measuredCoordinate.y)
            self?.measuredMotion?.axisZ.append(measuredCoordinate.z)
        }
    }
    
    private func stopMeasure() {
        canChangeMotionType = true
        motionManager.stop()
    }
}

// MARK: Bind Method
extension MeasureViewModel {
    func bindCanChangeMotionType(handler: @escaping (Bool) -> Void) {
        canChangeMotionTypeHandler = handler
    }
}
