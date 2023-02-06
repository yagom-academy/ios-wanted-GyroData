//  GyroData - CoreDataManager.swift
//  Created by zhilly, woong on 2023/02/03

import Foundation
import CoreData

final class CoreDataManager: CoreDataManageable {
    
    static let shared = CoreDataManager()
    private let fileManager = FileManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Motion")
        
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
    
    private init() {}
    
    func add(_ motionData: MotionData) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "MotionCoreModel", in: context) else {
            throw CoreDataManagerError.failedFetchEntity
        }
        let motionObject = NSManagedObject(entity: entity, insertInto: context)
        
        motionObject.setValue(motionData.createdAt, forKey: "createdAt")
        motionObject.setValue(motionData.runtime, forKey: "runtime")
        motionObject.setValue(motionData.sensorType.rawValue, forKey: "sensorType")
        motionObject.setValue(motionData.sensorData.x, forKey: "xData")
        motionObject.setValue(motionData.sensorData.y, forKey: "yData")
        motionObject.setValue(motionData.sensorData.z, forKey: "zData")
        
        if context.hasChanges {
            try context.save()
        }
        
        let saveToData = FileManagedData(createdAt: motionData.createdAt,
                                         runtime: motionData.runtime,
                                         sensorData: motionData.sensorData)
        fileManager.add(fileName: DateFormatter.convertToFileFormat(date: saveToData.createdAt),
                        fileManagedData: saveToData)
    }
    
    func fetchObjects() throws -> [MotionData] {
        let fetchRequest: NSFetchRequest<MotionCoreModel> = MotionCoreModel.fetchRequest()
        let result = try context.fetch(fetchRequest)
        
        return result.compactMap({ MotionData(from: $0) })
    }
    
    func update(_ motionData: MotionData) throws {
        guard let objectID = fetchObjectID(from: motionData.objectID) else {
            throw CoreDataManagerError.invalidObjectID
        }
        let motionObject = context.object(with: objectID)
        
        motionObject.setValue(motionData.createdAt, forKey: "createdAt")
        motionObject.setValue(motionData.runtime, forKey: "runtime")
        motionObject.setValue(motionData.sensorType, forKey: "sensorType")
        motionObject.setValue(motionData.sensorData.x, forKey: "xData")
        motionObject.setValue(motionData.sensorData.y, forKey: "yData")
        motionObject.setValue(motionData.sensorData.z, forKey: "zData")
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    func remove(_ motionData: MotionData) throws {
        guard let objectID = fetchObjectID(from: motionData.objectID) else {
            throw CoreDataManagerError.invalidObjectID
        }
        let motionObject = context.object(with: objectID)
        
        context.delete(motionObject)
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    private func fetchObjectID(from motionID: String?) -> NSManagedObjectID? {
        guard let motionID = motionID,
              let objectURL = URL(string: motionID),
              let storeCoordinator = context.persistentStoreCoordinator,
              let objectID = storeCoordinator.managedObjectID(forURIRepresentation: objectURL) else {
            return nil
        }
        
        return objectID
    }
}
