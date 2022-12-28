//
//  MotionDataViewModel.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/27.
//
import Foundation

final class MotionDataViewModel {
    var records = [MotionRecord]()

    init() {
        setUpMockData()
    }

    private func setUpMockData() {
        records = [
            MotionRecord(id: UUID(), startDate: Date(), msInterval: 10,
                         motionMode: .accelerometer, coordinates: [Coordiante(x: 1, y: 1, z: 1)]),
            MotionRecord(id: UUID(), startDate: Date(), msInterval: 10,
                         motionMode: .gyroscope, coordinates: [Coordiante(x: 1, y: 1, z: 1)]),
            MotionRecord(id: UUID(), startDate: Date(), msInterval: 10,
                         motionMode: .gyroscope, coordinates: [Coordiante(x: 1, y: 1, z: 1)]),
            MotionRecord(id: UUID(), startDate: Date(), msInterval: 10,
                         motionMode: .accelerometer, coordinates: [Coordiante(x: 1, y: 1, z: 1)]),
            MotionRecord(id: UUID(), startDate: Date(), msInterval: 10,
                         motionMode: .accelerometer, coordinates: [Coordiante(x: 1, y: 1, z: 1)]),
        ]
    }
}
