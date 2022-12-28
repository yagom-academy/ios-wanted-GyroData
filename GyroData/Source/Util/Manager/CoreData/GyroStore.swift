//
//  GyroStore.swift
//  GyroData
//
//  Created by dhoney96 on 2022/12/26.
//

import CoreData

class GyroStore {
    private let dataStack: CoreDataStack
    
    private var context: NSManagedObjectContext {
        return dataStack.viewContext
    }
    
    init(dataStack: CoreDataStack = CoreDataStack.shared) {
        self.dataStack = dataStack
    }
    
    //MARK: create
    func create(by dict: [String: Any]) throws {
        let gyro = Gyro(context: self.context)
        
        dict.forEach { (key: String, value: Any) in
            gyro.setValue(value, forKey: key)
        }
        
        try self.save(context)
    }
    
    //MARK: read
    func read(limitCount: Int) throws -> [Gyro] {
        let request = NSFetchRequest<Gyro>(entityName: "Gyro")
        request.fetchLimit = limitCount
        let gyroData = try context.fetch(request)
        
        return gyroData
    }
    
    //MARK: DetailRead
    func readDetailData(measurementDate: String) throws -> [Gyro] {
        let request = NSFetchRequest<Gyro>(entityName: "Gyro")
        request.predicate = NSPredicate(format: "measurementDate = %@", measurementDate as CVarArg)
        let gyroData = try context.fetch(request)
        
        return gyroData
    }
    
    //MARK: delete
    func delete(measurementDate: String) throws {
        let request = NSFetchRequest<Gyro>(entityName: "Gyro")
        request.predicate = NSPredicate(format: "measurementDate = %@", measurementDate as CVarArg)
        
        guard let gyro = try context.fetch(request).first else {
            return
        }
        
        self.context.delete(gyro)
        try self.save(self.context)
    }
    
    //MARK: count
    func getEntityCount() -> Int {
        let request = NSFetchRequest<Gyro>(entityName: "Gyro")
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            return 0
        }
    }
    
    private func save(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else {
            return
        }
        
        do {
            try  context.save()
        } catch {
            throw error
        }
    }
}
