//
//  CoreDataManager.swift
//  GyroData
//
//  Created by stone, LJ on 2023/02/01.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init () { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MotionData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
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
    
    func fetchData<T: NSManagedObject>(entity: T.Type) -> [T]? {
        let fetchRequest = NSFetchRequest<T>(entityName: T.self.description())
        
        let dateOrder = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateOrder]

        let context = self.persistentContainer.viewContext
        
        do{
            return try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return nil
    }
    
    func create<T: NSManagedObject>(entity: T.Type, completion: (T) -> Void) {
        let context = self.persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: T.self.description(), in: context) else { return }

        guard let managedObject = NSManagedObject(entity: entityDescription, insertInto: context) as? T else { return }
        
        completion(managedObject)

        self.saveContext()
    }
    
    func delete(entity: NSManagedObject) {
        let context = self.persistentContainer.viewContext
        context.delete(entity)
        self.saveContext()
    }
}
