//
//  MotionDataListStorageProtocol.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/28.
//

import Foundation

protocol MotionDataListStorageProtocol {
    func loadMotionRecords(
        page: Int,
        completion: @escaping (Result<[MotionRecord], Error>) -> Void
    )
    func deleteRecord(
        id: UUID,
        completion: @escaping (Result<Never, Error>) -> Void
    )
}
