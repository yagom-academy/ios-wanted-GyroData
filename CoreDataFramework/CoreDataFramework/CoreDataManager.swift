//
//  CoreDataManager.swift
//  CoreDataFramework
//
//  Created by 백곰 on 2022/08/25.
//

import Foundation
import CoreData

public struct SaveModel {
    let entityName: String
    let sampleData: [String: Any]
    
    public init(entityName: String, sampleData: [String: Any]) {
        self.entityName = entityName
        self.sampleData = sampleData
    }
}

public class CoreDataManager {
    public static let shared = CoreDataManager()
    private init() { }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func fetch<T>(_ request: NSFetchRequest<T>) -> [T]? {
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            return result
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    public func save(model: SaveModel, request: NSFetchRequest<NSFetchRequestResult>) {
        let context = persistentContainer.viewContext
        
        do {
            guard let object = try context.fetch(request).last as? NSManagedObject else {
                let entity = NSEntityDescription.insertNewObject(forEntityName: model.entityName, into: context)
                entity.setValuesForKeys(model.sampleData)
                return
            }
            
            object.setValuesForKeys(model.sampleData)
        } catch {
            print(error.localizedDescription)
        }

        saveContext()
    }
        
    public func delete(_ request: NSFetchRequest<NSFetchRequestResult>) {
        let context = persistentContainer.viewContext
        
        do {
            guard let objects = try context.fetch(request) as? [NSManagedObject] else { return }
            
            objects.forEach {
                context.delete($0)
            }
        } catch {
            print(error.localizedDescription)
        }

        saveContext()
    }
}
