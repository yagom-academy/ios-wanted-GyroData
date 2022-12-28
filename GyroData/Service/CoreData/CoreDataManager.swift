//
//  CoreDataManager.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/28.
//

import Foundation
import CoreData

protocol CoreDataManagable {
    func save()
    func delete(_ request: NSFetchRequest<NSFetchRequestResult>)
    func fetch<T: Storable>(_ request: NSFetchRequest<T>) -> [T]?
}

class CoreDataManager: CoreDataManagable {
    weak var coreDataStack: CoreDataStack?
    
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
    
    func save() {
        coreDataStack?.saveContext()
    }
    
    func delete(_ request: NSFetchRequest<NSFetchRequestResult>) {
        guard let context = coreDataStack?.managedContext else { return }
        
        do {
            guard let objects = try context.fetch(request) as? [NSManagedObject] else { return }
            
            objects.forEach {
                context.delete($0)
            }
        } catch {
            print(error.localizedDescription)
        }

        coreDataStack?.saveContext()
    }
    
    func fetch<T: Storable>(_ request: NSFetchRequest<T>) -> [T]? {
        do {
            let result = try coreDataStack?.managedContext.fetch(request)
            return result
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
