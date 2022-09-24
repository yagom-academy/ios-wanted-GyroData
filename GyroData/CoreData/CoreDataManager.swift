//
//  CoreDataManager.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static var shared: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GyroModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    var entityName: NSEntityDescription? {
        return  NSEntityDescription.entity(forEntityName: "GyroModel", in: context)
    }
 
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    @discardableResult
    func insertMeasure(measure: Measure) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "GyroModel", in: self.context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            
            managedObject.setValue(measure.id, forKey: "id")
            managedObject.setValue(measure.title, forKey: "title")
            managedObject.setValue(measure.second, forKey: "second")
            managedObject.setValue(measure.measureDate, forKey: "measureDate")
            
            do {
                try self.context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    
    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
}
