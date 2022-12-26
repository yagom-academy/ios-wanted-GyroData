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
    
    // create
    func create(by dict: [String: Any]) throws {
        let gyro = Gyro(context: self.context)
        
        dict.forEach { (key: String, value: Any) in
            gyro.setValue(value, forKey: key)
        }
        
        try self.save(context)
    }
    
    // read
    func read() throws -> [Gyro] { // DTO 객체가 반드시 필요한지 고민
        let request = NSFetchRequest<Gyro>(entityName: "Gyro")
        let gyroData = try context.fetch(request)
        
        return gyroData
    }
    
    // delete
    func delete(measurementDate: String) throws {
        let request = NSFetchRequest<Gyro>(entityName: "Gyro")
        request.predicate = NSPredicate(format: "measurementDate = %@", measurementDate as CVarArg)
        
        guard let gyro = try context.fetch(request).first else {
            return // 에러 처리
        }
        
        self.context.delete(gyro)
        try self.save(self.context)
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
