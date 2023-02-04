//
//  PersistentContainerManager.swift
//  GyroData
//
//  Created by Mangdi on 2023/01/31.
//

import CoreData

final class PersistentContainerManager {
    static let shared = PersistentContainerManager()
    private init() { }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = PersistentContainerManager.shared.persistentContainer.viewContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            return
        }
    }
    
    func createNewGyroObject(
        metaData: TransitionMetaData,
        completion: @escaping (Result<Void, FileWriteError>) -> Void
    ) {
        let context = persistentContainer.viewContext
        let newObject = TransitionMetaDataObject(context: context)
        
        newObject.setValue(metaData.saveDate, forKey: "saveDate")
        newObject.setValue(metaData.sensorType.rawValue, forKey: "sensorType")
        newObject.setValue(metaData.recordTime, forKey: "recordTime")
        newObject.setValue(metaData.jsonName, forKey: "jsonName")
        newObject.setValue(metaData.id, forKey: "id")
        
        guard let _ = try? context.save() else {
            completion(.failure(.writeError))
            return
        }
        
        completion(.success(()))
    }

    private func fetchAllTransitionMetaDataObjects() -> [TransitionMetaDataObject] {
        do {
            let request = TransitionMetaDataObject.fetchRequest()
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchTransitionMetaData(pageCount: Int, limit: Int = 10) -> [TransitionMetaData] {
        let request = TransitionMetaDataObject.fetchRequest()
        request.fetchOffset = pageCount * limit
        request.fetchLimit = limit
        guard let objects = try? context.fetch(request) else {
            return []
        }
        return objects.compactMap { $0.metaData }
    }

    func deleteTransitionMetaData(data: TransitionMetaData) {
        let fetchTransitionMetaDataObjects = fetchAllTransitionMetaDataObjects()
        guard let transitionMetaDataObject = fetchTransitionMetaDataObjects.first(where: { $0.id == data.id }) else { return }
        persistentContainer.viewContext.delete(transitionMetaDataObject)
        saveContext()
    }
}
