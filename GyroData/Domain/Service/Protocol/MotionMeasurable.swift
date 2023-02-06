//
//  MotionMeasurable.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/02/02.
//

protocol MotionMeasurable {
    func measure(
        type: Motion.MeasurementType,
        measurementHandler: @escaping (MotionDataType) -> Void,
        completeHandler: @escaping (Bool) -> Void)
    func stopMeasurement(type: Motion.MeasurementType)
}
