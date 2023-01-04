//
//  FetchMotionDataUseCase.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/30.
//

import Foundation

final class FetchMotionDataUseCase {
    private let storage = MotionReplayStorage()

    func execute(id: UUID, completion: @escaping (Result<MotionRecord, Error>) -> Void) {
        storage.loadMotionRecord(id: id) { result in
            switch result {
            case .success(let record):
                completion(.success(record))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
