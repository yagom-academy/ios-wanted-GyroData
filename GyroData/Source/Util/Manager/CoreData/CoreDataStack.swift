//
//  CoreDataStack.swift
//  GyroData
//
//  Created by dhoney96 on 2022/12/26.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack(inMemory: false)

    private let inMemory: Bool
    
    lazy var persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Gyro")
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(string: "/dev/null")
            description.shouldAddStoreAsynchronously = false //비동기 적으로 저장하는 걸 방지
            
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores { (_, error) in
            if error != nil {
                fatalError("Failure load core data persistent stores")
            }
        }
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return self.persistantContainer.viewContext
    }
    
    init(inMemory: Bool = true) {
        self.inMemory = inMemory
    }
}
