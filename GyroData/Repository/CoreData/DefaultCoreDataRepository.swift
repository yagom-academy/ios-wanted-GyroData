//
//  DefaultCoreDataRepository.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import CoreData

enum CoreDataError: Error {
    case invalidEntity
}

struct DefaultCoreDataRepository: CoreDataRepository {
    typealias Domain = Motion
    typealias Entity = MotionMO
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GyroData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func create(_ domain: Motion) throws {
        
    }
    
    func read(from offset: Int) throws -> [MotionMO] {
        return []
    }
    
    func read(with id: String) throws -> MotionMO {
        return MotionMO(context: context)
    }
    
    func delete(_ id: String) throws {
        
    }
}
