//
//  MockStorage.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/28.
//

import Foundation

final class MockStorage: MotionDataListStorageProtocol {
    func loadMotionRecords(page: Int, completion: @escaping (Result<[MotionRecord], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success(self.mockData()))
        }
    }

    func deleteRecord(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }

    private func mockData() -> [MotionRecord] {
        return [
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
