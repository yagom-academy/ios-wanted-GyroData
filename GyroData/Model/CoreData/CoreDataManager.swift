//
//  CoreDataManager.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import Foundation
import CoreData

class CoreDataManager {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MotionDataModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                preconditionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    var motionDataEntity: NSEntityDescription? {
        return  NSEntityDescription.entity(forEntityName: "MotionDataEntity", in: context)
    }

    // MARK: - CREATE
    func create(entity: MotionData) throws {
        createEntity(motionData: entity)
        try saveContext()
    }

    private func createEntity(motionData: MotionData) {
        if let entity = motionDataEntity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(motionData.date, forKey: "date")
            managedObject.setValue(motionData.id, forKey: "id")
            managedObject.setValue(motionData.time, forKey: "time")
            managedObject.setValue(motionData.type.rawValue, forKey: "type")
            managedObject.setValue(motionData.value.map { $0.x }, forKey: "xValue")
            managedObject.setValue(motionData.value.map { $0.y }, forKey: "yValue")
            managedObject.setValue(motionData.value.map { $0.z }, forKey: "zValue")
        }
    }

    private func saveContext() throws {
        if !context.hasChanges {
            return
        }

        try context.save()
    }

    // MARK: - READ
    func readDiaryEntity() -> [MotionDataEntity] {
        return fetchMotionDataEntity()
    }

    private func fetchMotionDataEntity() -> [MotionDataEntity] {
        do {
            let request = MotionDataEntity.fetchRequest()
            let results = try context.fetch(request)

            return results
        } catch {
            print(error.localizedDescription)
        }

        return []
    }

    // MARK: - DELETE
    func delete(motionDataId: UUID) {
        let fetchResults = fetchMotionDataEntity()
        guard let motionDataEntity = fetchResults.first(where: { $0.id == motionDataId }) else {
            return
        }

        context.delete(motionDataEntity)
        try? saveContext()
    }
}

