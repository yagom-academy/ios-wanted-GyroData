//
//  DefaultCoreDataRepository.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import CoreData

enum CoreDataError: Error {
    case invalidEntity
    case invalidID
}

struct DefaultCoreDataRepository: CoreDataRepository {
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GyroData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let context: NSManagedObjectContext
    
    init() {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        self.context = context
    }
    
    func create(_ domain: Motion, completion: @escaping (Result<Void, Error>) -> Void) {
        context.perform {
            guard let entity = NSEntityDescription.entity(
                forEntityName: "MotionMO",
                in: self.context
            ) else {
                return completion(.failure(CoreDataError.invalidEntity))
            }
            
            let motionMO = MotionMO(entity: entity, insertInto: self.context)
            
            motionMO.setValue(domain.id, forKey: "id")
            motionMO.setValue(domain.date.timeIntervalSince1970, forKey: "date")
            motionMO.setValue(domain.type.rawValue, forKey: "type")
            motionMO.setValue(domain.time, forKey: "time")
            motionMO.setValue(domain.data.x, forKey: "x")
            motionMO.setValue(domain.data.y, forKey: "y")
            motionMO.setValue(domain.data.z, forKey: "z")
            
            do {
                try self.context.save()
            } catch {
                completion(.failure(error))
            }
            completion(.success(()))
        }
    }
    
    func read(from offset: Int) throws -> [MotionMO] {
        let request = MotionMO.fetchRequest()
        request.fetchOffset = offset
        request.fetchLimit = offset + 9
        
        let result = try context.fetch(request)
        return result
    }
    
    func delete(with id: String) throws {
        let request = MotionMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        guard let target = try context.fetch(request).first else { throw CoreDataError.invalidID }
        context.delete(target)
        
        try context.save()
    }
}
