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

    @discardableResult
    func saveContext() -> Bool {
        let context = PersistentContainerManager.shared.persistentContainer.viewContext
        
        guard context.hasChanges else { return false }
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func createNewGyroObject(metaData: TransitionMetaData) -> Bool {
        let context = persistentContainer.viewContext
        let newObject = TransitionMetaDataObject(context: context)
        print("path in core Data \(metaData.jsonName)")
        newObject.setValue(metaData.saveDate, forKey: "saveDate")
        newObject.setValue(metaData.sensorType.rawValue, forKey: "sensorType")
        newObject.setValue(metaData.recordTime, forKey: "recordTime")
        newObject.setValue(metaData.jsonName, forKey: "jsonName")
        newObject.setValue(metaData.id, forKey: "id")
        
        return saveContext()
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

    private func fetchTenTransitionMetaDataObjects(pageCount: Int) -> [TransitionMetaDataObject] {
        do {
            let request = TransitionMetaDataObject.fetchRequest()
            request.fetchOffset = pageCount * 10
            request.fetchLimit = 10
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchTenTransitionMetaDatas(pageCount: Int) -> [TransitionMetaData] {
        let fetchTenTransitionMetaDataObjects = fetchTenTransitionMetaDataObjects(pageCount: pageCount)
        let transitionMetaDatas = fetchTenTransitionMetaDataObjects.map {
            TransitionMetaData(saveDate: $0.saveDate,
                               sensorType: SensorType(rawValue: $0.sensorType) ?? SensorType.Accelerometer,
                               recordTime: $0.recordTime,
                               jsonName: $0.jsonName)
        }
        return transitionMetaDatas
    }

    func deleteTransitionMetaData(data: TransitionMetaData) {
        let fetchTransitionMetaDataObjects = fetchAllTransitionMetaDataObjects()
        guard let transitionMetaDataObject = fetchTransitionMetaDataObjects.first(where: { $0.id == data.id }) else { return }
        persistentContainer.viewContext.delete(transitionMetaDataObject)
        saveContext()
    }
}
