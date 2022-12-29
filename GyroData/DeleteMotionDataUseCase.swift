//
//  DeleteMotionDataUseCase.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/28.
//

import Foundation

final class DeleteMotionDataUseCase {
    private let motionDataListStorage: MotionDataListStorageProtocol

    init(motionDataListStorage: MotionDataListStorageProtocol) {
        self.motionDataListStorage = motionDataListStorage
    }

    func execute(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        motionDataListStorage.deleteRecord(id: id) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
