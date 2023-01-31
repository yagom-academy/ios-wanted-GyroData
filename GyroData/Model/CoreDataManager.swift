//
//  CoreDataManager.swift
//  GyroData
//
//  Created by junho lee on 2023/01/31.
//

import CoreData

final class CoreDataManager: CoreDataManageable {
    static let shared = CoreDataManager()
    private lazy var persistentContainer = {
        let container = NSPersistentContainer(name: "MotionData")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private init() {
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func fetchMotionDataEntities() -> [MotionDataEntity] {
        do {
            let request = MotionDataEntity.fetchRequest()
            let result = try context.fetch(request)
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func readAll() -> [MotionData] {
        let motionDataEntities = fetchMotionDataEntities()
        return motionDataEntities.compactMap { motionDataEntity in
            guard let motionDataType = MotionDataType.init(rawValue: motionDataEntity.motionDataType) else {
                return nil
            }
            return MotionData(id: motionDataEntity.id,
                              createdAt: motionDataEntity.createdAt,
                              length: motionDataEntity.length,
                              motionDataType: motionDataType)
        }
    }

    func add(_ motionData: MotionData) {
        let motionDataEntity = MotionDataEntity(context: context)
        motionDataEntity.id = motionData.id
        motionDataEntity.createdAt = motionData.createdAt
        motionDataEntity.length = motionData.length
        motionDataEntity.motionDataType = motionData.motionDataType.rawValue
        saveContext()
    }

    func delete(_ motionData: MotionData) {
        let motionDataEntities = fetchMotionDataEntities()
        guard let motionDataEntity = motionDataEntities.first(where: { $0.id == motionData.id }) else { return }
        context.delete(motionDataEntity)
        saveContext()
    }
}
