//
//  MeasermentViewModel.swift
//  GyroData
//
//  Created by 우롱차 on 2022/12/27.
//

import Foundation

protocol MeasermentViewModelInput {
    
    func measerStart(type: MotionType)
    
}

protocol MeasermentViewModelOutput {
    
    var motions: Observable<[MotionValue]> { get }
    var currentMotion: Observable<MotionValue?> { get }
    
}

protocol MeasermentViewModel: MeasermentViewModelInput, MeasermentViewModelOutput {}

final class DefaultMeasermentViewModel: MeasermentViewModel {
    
    private let coreMotionManager: CoreMotionManager
    var motions: Observable<[MotionValue]> = .init([])
    
    var currentMotion: Observable<MotionValue?> = .init(nil)
    
    init(
        manger: CoreMotionManager = CoreMotionManager()
    ) {
        self.coreMotionManager = manger
        
    }
    
    func measerStart(type: MotionType) {
        switch type {
        case .gyro:
            coreMotionManager.bind(gyroHandler: { data, error in
                if let data = data {
                    let motionValue = MotionValue(data)
                    self.currentMotion = Observable(motionValue)
                    self.motions.value.append(motionValue)
                }
            })
        case .accelerometer:
            coreMotionManager.bind(accHandler: { data, error in
                if let data = data {
                    let motionValue = MotionValue(data)
                    self.currentMotion = Observable(motionValue)
                    self.motions.value.append(motionValue)
                }
            })
        }
    }
}
