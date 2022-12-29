//
//  FetchMotionDataListUseCase.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/28.
//

import Foundation

final class FetchMotionDataListUseCase {
    private let motionDataListStorage: MotionDataListStorageProtocol

    init(motionDataListStorage: MotionDataListStorageProtocol = MotionDataListStorage()) {
        self.motionDataListStorage = motionDataListStorage
    }

    func execute(page: Int, completion: @escaping (Result<FetchMotionDataListResponse, Error>) -> Void) {
        motionDataListStorage.loadMotionRecords(page: page) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct FetchMotionDataListResponse {
    let records: [MotionRecord]
    let currentPage: Int
    let hasNextPage: Bool
}
