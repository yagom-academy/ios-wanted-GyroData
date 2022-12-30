//
//  MotionReplayStorageProtocol.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/30.
//

import Foundation

protocol MotionReplayStorageProtocol {
    func loadMotionRecord(id: UUID, completion: @escaping (Result<MotionRecord, Error>) -> Void)
}
