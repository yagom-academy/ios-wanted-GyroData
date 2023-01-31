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
        guard let entity = NSEntityDescription.entity(
            forEntityName: "MotionMO",
            in: context
        ) else {
            throw CoreDataError.invalidEntity
        }
        
        let motionMO = NSManagedObject(entity: entity, insertInto: context)
        
        motionMO.setValue(domain.id, forKey: "id")
        motionMO.setValue(domain.date.timeIntervalSince1970, forKey: "date")
        motionMO.setValue(domain.type.rawValue, forKey: "type")
        motionMO.setValue(domain.time, forKey: "time")
        motionMO.setValue(domain.data.x, forKey: "x")
        motionMO.setValue(domain.data.y, forKey: "y")
        motionMO.setValue(domain.data.z, forKey: "z")
        
        try context.save()
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
