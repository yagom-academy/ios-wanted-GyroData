//
//  CoreDataManager.swift
//  GyroData
//
//  Created by junho lee on 2023/01/31.
//

import CoreData

final class CoreDataManager: CoreDataManageable {
    typealias FetchRequest = NSFetchRequest<MotionDataEntity>
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
    private var request: FetchRequest {
        MotionDataEntity.fetchRequest()
    }

    private init() { }

    private func saveContext() throws {
        guard context.hasChanges else { return }
        try context.save()
    }

    private func fetchMotionDataEntities(_ request: FetchRequest) throws -> [MotionDataEntity] {
        return try context.fetch(request)
    }

    func read(offset: Int, limit: Int) throws -> [MotionDataEntity] {
        let request = MotionDataEntity.fetchRequest()
        request.fetchOffset = offset
        request.fetchLimit = limit
        return try fetchMotionDataEntities(request)
    }

    func save(_ motionData: MotionData) throws {
        let motionDataEntity = MotionDataEntity(context: context)
        motionDataEntity.id = motionData.id
        motionDataEntity.createdAt = motionData.createdAt
        motionDataEntity.length = motionData.length
        motionDataEntity.motionDataType = motionData.motionDataType.rawValue
        try saveContext()
    }

    func delete(_ id: UUID) throws {
        let motionDataEntities = try fetchMotionDataEntities(request)
        guard let motionDataEntity = motionDataEntities.first(where: { $0.id == id }) else { return }
        context.delete(motionDataEntity)
        try saveContext()
    }
}
