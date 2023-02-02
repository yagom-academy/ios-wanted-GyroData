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
