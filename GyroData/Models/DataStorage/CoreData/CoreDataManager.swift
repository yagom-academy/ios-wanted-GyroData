//
//  CoreDataManager.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/02/01.
//

import Foundation
import CoreData

struct CoreDataManager {
    
    typealias DataType = Measurement
    
    private let persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "GyroCoreData")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as? NSError {
                fatalError("unresolved Error \(error), \(error.userInfo)")
            }
        }
        
        return persistentContainer
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
