//
//  CoreDataStack.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import CoreData

fileprivate enum Literals {
    static let motionModel = "MotionModel"
}

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy private var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Literals.motionModel)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as? NSError {
                fatalError("Unresolved Error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func createBackgroundContext() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }
}
