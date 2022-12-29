//
//  MotionDataListStorage.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/28.
//

import CoreData

final class MotionDataListStorage: MotionDataListStorageProtocol {
    private let coreDataStorage = CoreDataStorage.shared

    func loadMotionRecords(page: Int, completion: @escaping (Result<[MotionRecord], Error>) -> Void) {
        let context = coreDataStorage.persistentContainer.viewContext
        DispatchQueue.global().async {
            do {
                let request: NSFetchRequest = MotionRecordEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: #keyPath(MotionRecordEntity.startDate), ascending: false)]
                request.fetchLimit = 10
                let result = try context.fetch(request).map { $0.toDomain() }

                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func deleteRecord(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStorage.persistentContainer.viewContext
        DispatchQueue.global().async {
            do {
                let request: NSFetchRequest = MotionRecordEntity.fetchRequest()
                if let objectToDelete = try context.fetch(request).filter({ $0.motionRecordId == id }).first {
                    context.delete(objectToDelete)
                    completion(.success(()))
                }
                try context.save()
            } catch {
                completion(.failure(error))
            }
        }
    }
}
