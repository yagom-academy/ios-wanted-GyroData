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

    private func saveContext() throws {
        guard context.hasChanges else { return }
        try context.save()
    }

    private func fetchMotionDataEntities() throws -> [MotionDataEntity] {
        let request = MotionDataEntity.fetchRequest()
        return try context.fetch(request)
    }

    func readAll() throws -> [MotionData] {
        let motionDataEntities = try fetchMotionDataEntities()
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

    func add(_ motionData: MotionData) throws {
        let motionDataEntity = MotionDataEntity(context: context)
        motionDataEntity.id = motionData.id
        motionDataEntity.createdAt = motionData.createdAt
        motionDataEntity.length = motionData.length
        motionDataEntity.motionDataType = motionData.motionDataType.rawValue
        try saveContext()
    }

    func delete(_ motionData: MotionData) throws {
        let motionDataEntities = try fetchMotionDataEntities()
        guard let motionDataEntity = motionDataEntities.first(where: { $0.id == motionData.id }) else { return }
        context.delete(motionDataEntity)
        try saveContext()
    }
}
