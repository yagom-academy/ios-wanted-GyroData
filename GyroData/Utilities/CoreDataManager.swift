//
//  CoreDataManager.swift
//  GyroData
//
//  Created by channy on 2022/09/21.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case fetchError
    case insertError
    case entityError
    case deleteError
}

class CoreDataManager {
    
    static var shared: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MotionModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unsolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func fetchMotionTasks() async throws -> [Motion] {
        let request = Motion.fetchRequest()
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            throw CoreDataError.fetchError
        }
    }
    
    @discardableResult
    func insertMotionTask(motion: MotionTask) async throws -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Motion", in: self.context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            
            managedObject.setValue(motion.type, forKey: "type")
            managedObject.setValue(motion.time, forKey: "time")
            managedObject.setValue(motion.date, forKey: "date")
            managedObject.setValue(motion.path, forKey: "path")
            
            do {
                try self.context.save()
                return true
            } catch {
                // MARK: save 실패할 경우 에러 처리
                throw CoreDataError.insertError
            }
        } else {
            throw CoreDataError.entityError
        }
    }
    
    @discardableResult
    func deleteMotionTask(motion: MotionTask) async throws -> Bool {
        let fetchResults = try await CoreDataManager.shared.fetchMotionTasks()
        let object = fetchResults.filter ({ $0.date == motion.date })[0]
        print(object)
        
        self.context.delete(object)
        do {
            try context.save()
            return true
        } catch {
            throw CoreDataError.deleteError
        }
    }
    
    func count<T: NSManagedObject>(request: NSFetchRequest<T>) -> Int? {
        do {
            let count = try self.context.count(for: request)
            return count
        } catch {
            return nil
        }
    }
}
