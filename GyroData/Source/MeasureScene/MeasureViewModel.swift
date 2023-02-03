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
    
    func action(_ action: Action) {
        switch action {
        case .motionTypeChange(let type):
            verifyMotionType(with: type)
            break
        case .measure:
            // TODO: 측정 시작
            break
        case .stop:
            // TODO: 정지
            break
        case .save:
            // TODO: 저장
            break
        }
    }
    
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
}
