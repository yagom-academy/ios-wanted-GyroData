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
    
    func createNewGyroObject(metaData: TransitionMetaData) {
        let context = persistentContainer.viewContext
        let newObject = TransitionMetaDataObject(context: context)
        
        newObject.setValue(metaData.saveDate, forKey: "saveDate")
        newObject.setValue(metaData.sensorType.rawValue, forKey: "sensorType")
        newObject.setValue(metaData.recordTime, forKey: "recordTime")
        newObject.setValue(metaData.jsonName, forKey: "jsonName")
        newObject.setValue(metaData.id, forKey: "id")
        
        saveContext()
    }

    private func fetchGyroModelObject() -> [TransitionMetaDataObject] {
        do {
            let request = TransitionMetaDataObject.fetchRequest()
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchGyroModels() -> [TransitionMetaData] {
        let gyroModelObjects = fetchGyroModelObject()
        let gyroModels = gyroModelObjects.map {
            TransitionMetaData(saveDate: $0.saveDate,
                      sensorType: SensorType(rawValue: $0.sensorType) ?? SensorType.Accelerometer,
                      recordTime: $0.recordTime,
                      jsonName: $0.jsonName)
        }
        return gyroModels
    }
}
