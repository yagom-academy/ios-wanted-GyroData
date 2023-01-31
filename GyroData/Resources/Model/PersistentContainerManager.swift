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

    func saveContext() {
        let context = PersistentContainerManager.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    private func fetchTransitionMetaDataObjects() -> [TransitionMetaDataObject] {
        do {
            let request = TransitionMetaDataObject.fetchRequest()
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchTransitionMetaDatas() -> [TransitionMetaData] {
        let fetchTransitionMetaDataObjects = fetchTransitionMetaDataObjects()
        let transitionMetaDatas = fetchTransitionMetaDataObjects.map {
            TransitionMetaData(saveDate: $0.saveDate,
                               sensorType: SensorType(rawValue: $0.sensorType) ?? SensorType.Accelerometer,
                               recordTime: $0.recordTime,
                               jsonName: $0.jsonName)
        }
        return transitionMetaDatas
    }

    func deleteTransitionMetaData(data: TransitionMetaData) {
        let fetchTransitionMetaDataObjects = fetchTransitionMetaDataObjects()
        guard let transitionMetaDataObject = fetchTransitionMetaDataObjects.first(where: { $0.id == data.id }) else { return }
        persistentContainer.viewContext.delete(transitionMetaDataObject)
        saveContext()
    }
}
