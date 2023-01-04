//
//  CoreDataManager.swift
//  GyroData
//
//  Created by 정재근 on 2022/12/29.
//

import Foundation
import CoreData

class CoreDataManager {
    static var shared = CoreDataManager()

    var context: NSManagedObjectContext { return self.persistentContainer.viewContext }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MeasureDataModel")
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
}
