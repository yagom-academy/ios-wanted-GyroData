//
//  File.swift
//  GyroData
//
//  Created by Judy on 2022/12/29.
//

import Foundation

protocol MotionMeasurementViewModelInput {
    func save(_ motionType: MotionType, datas: [[Double]])
}

protocol MotionMeasurementViewModelOutput {
    var measurementedMotion: Observable<[MotionInformation]> { get }
    var error: Observable<String> { get }
}

protocol MotionMeasurementViewModelType: MotionMeasurementViewModelInput, MotionMeasurementViewModelOutput { }

class MotionMeasurementViewModel: MotionMeasurementViewModelType {
    private let motionCoreDataUseCase = MotionCoreDataUseCase()
    
    /// Output
    
    var measurementedMotion: Observable<[MotionInformation]> = Observable([])
    var error: Observable<String> = Observable("")
    
    /// Input
    
    func save(_ motionType: MotionType, datas: [[Double]]) {
        let newMotion = Motion(motionType: motionType,
                               date: Date(),
                               time: MotionMeasurementManager.shared.timeCount)
        
        motionCoreDataUseCase.save(item: newMotion)
        //TODO: - motionCoreDataUseCase.save(item: motion, motinData: datas)
    }
    
}
