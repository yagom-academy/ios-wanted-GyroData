//
//  File.swift
//  GyroData
//
//  Created by Judy on 2022/12/29.
//

import Foundation

protocol MotionMeasurementViewModelInput {
    func save(_ motionType: MotionType, datas: [[Double]])
    func startMeasurement(_ motionType: MotionType, on graphView: GraphView)
    func stopMeasurement(_ motionType: MotionType)
}

protocol MotionMeasurementViewModelOutput {
    var error: Observable<String> { get set }
    var isMeasuring: Observable<Bool> { get set }
    var loading: Observable<Bool> { get set }
}

protocol MotionMeasurementViewModelType: MotionMeasurementViewModelInput, MotionMeasurementViewModelOutput { }

class MotionMeasurementViewModel: MotionMeasurementViewModelType {
    private let motionCoreDataUseCase = MotionCoreDataUseCase()
    
    /// Output

    var error: Observable<String> = Observable("")
    var isMeasuring: Observable<Bool> = Observable(false)
    var loading: Observable<Bool> = Observable(false)
    
    /// Input
    
    func save(_ motionType: MotionType, datas: [[Double]]) {
        guard datas.isEmpty == false else {
            error.value = "측정된 데이터가 없습니다."
            return
        }
        
        loading.value = true
        let newMotion = Motion(motionType: motionType,
                               date: Date(),
                               time: MotionMeasurementManager.shared.timeCount)
        
        motionCoreDataUseCase.save(item: newMotion)
        //TODO: - motionCoreDataUseCase.save(item: motion, motinData: datas)
        loading.value = false
    }
    
    func startMeasurement(_ motionType: MotionType, on graphView: GraphView) {
        isMeasuring.value = true
        MotionMeasurementManager.shared.startMeasurement(motionType ,on: graphView)
    }
    
    func stopMeasurement(_ motionType: MotionType) {
        isMeasuring.value = false
        MotionMeasurementManager.shared.stopMeasurement(motionType)
    }
}
