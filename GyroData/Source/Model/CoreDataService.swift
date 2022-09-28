//
//  CoreDataService.swift
//  GyroData
//
//  Created by Subin Kim on 2022/09/27.
//

import Foundation
import CoreData

class CoreDataService {
    static let shared = CoreDataService()

    var context: NSManagedObjectContext { return self.persistentContainer.viewContext }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MotionDataModel")
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
