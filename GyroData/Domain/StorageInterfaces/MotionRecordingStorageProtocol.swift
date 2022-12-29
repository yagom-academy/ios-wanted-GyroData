//
//  MotionRecordingStorageProtocol.swift
//  GyroData
//
//  Created by YunYoungseo on 2022/12/29.
//

protocol MotionRecordingStorageProtocol {
    func saveRecord(record: MotionRecord, completion: @escaping (Result<Void, Error>) -> Void)
}
