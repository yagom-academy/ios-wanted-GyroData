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
    var error: Observable<String?> { get set }
    var isMeasuring: Observable<Bool> { get set }
    var loading: Observable<Bool?> { get set }
}

protocol MotionMeasurementViewModelType: MotionMeasurementViewModelInput, MotionMeasurementViewModelOutput { }

final class MotionMeasurementViewModel: MotionMeasurementViewModelType {
    private let motionCoreDataUseCase = MotionCoreDataUseCase()
    private let motionFileManagerUseCase = MotionFileManagerUseCase()
    
    /// Output

    var error: Observable<String?> = Observable(nil)
    var isMeasuring: Observable<Bool> = Observable(false)
    var loading: Observable<Bool?> = Observable(nil)
    
    /// Input
    
    func save(_ motionType: MotionType, datas: [[Double]]) {
        guard datas.isEmpty == false else {
            error.value = "측정된 데이터가 없습니다."
            return
        }
        
        loading.value = true
        let newMotion = MotionInformation(motionType: motionType,
                               date: Date(),
                               time: MotionMeasurementManager.shared.timeCount)
        
        motionCoreDataUseCase.save(item: newMotion) { result in
            switch result {
            case .success:
                self.loading.value = false
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
        motionFileManagerUseCase.save(newMotion, motinData: datas) { result in
            switch result {
            case .success:
                self.loading.value = false
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func startMeasurement(_ motionType: MotionType, on graphView: GraphView) {
        isMeasuring.value = true
        MotionMeasurementManager.shared.startMeasurement(motionType, on: graphView) {
            self.isMeasuring.value = false
        }
    }
    
    func stopMeasurement(_ motionType: MotionType) {
        isMeasuring.value = false
        MotionMeasurementManager.shared.stopMeasurement(motionType)
    }
}
