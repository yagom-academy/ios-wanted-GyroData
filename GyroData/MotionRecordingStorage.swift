//
//  MotionRecordingStorage.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/29.
//

import Foundation

final class MotionRecordingStorage {
    private let coreDataStorage = CoreDataStorage.shared

    func saveRecord(record: MotionRecord, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStorage.persistentContainer.viewContext
        DispatchQueue.global().async {
            let newRecord = MotionRecordEntity(context: context)
            newRecord.motionRecordId = record.id
            newRecord.startDate = record.startDate
            newRecord.msInterval = Int64(record.msInterval)
            newRecord.motionMode = record.motionMode.name

            record.coordinates.forEach {
                let newCoordinate = CoordinateEntity(context: context)
                newCoordinate.motionRecordId = record.id
                newCoordinate.x = $0.x
                newCoordinate.y = $0.y
                newCoordinate.z = $0.z
            }

            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}

fileprivate extension MotionMode {
    var name: String {
        switch self {
        case .accelerometer:
            return "acc"
        case .gyroscope:
            return "gyro"
        }
    }
}
