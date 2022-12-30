//
//  MotionReplayStorage.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/30.
//

import Foundation

final class MotionReplayStorage: MotionReplayStorageProtocol {
    private let fileStorage = FileStorage.shared

    func loadMotionRecord(id: UUID, completion: @escaping (Result<MotionRecord, Error>) -> Void) {
        fileStorage.loadFile(id: id) { result in
            switch result {
            case .success(let record):
                completion(.success(record.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
