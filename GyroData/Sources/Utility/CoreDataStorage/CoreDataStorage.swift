//
//  CoreDataManager.swift
//  GyroData
//
//  Created by Ari on 2022/12/26.
//

import Foundation
import CoreData

final class CoreDataStorage {
    
    static let shared = CoreDataStorage()
    private init() {}

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CoreDataStorage")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
}

extension CoreDataStorage {
    
    func getMotion(_ context: NSManagedObjectContext, page: UInt = 1) throws -> [MotionEntity] {
        let request = MotionEntity.fetchRequest()
        request.fetchLimit = 10
        request.fetchOffset = Int(page * 10) - 10
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateSort]
        return try context.fetch(request)
    }
    
}

extension NSManagedObjectContext {
    
    func saveContext() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                let nsError = error as NSError
                debugPrint("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}
