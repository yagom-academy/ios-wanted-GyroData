//
//  MockMotionRecordingStorage.swift
//  GyroData
//
//  Created by YunYoungseo on 2022/12/29.
//

import Foundation

final class MockMotionRecordingStorage: MotionRecordingStorageProtocol {
    func saveRecord(record: MotionRecord, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success(()))
        }
    }
}
