//
//  CoreDataManager.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case saveFailure
    case fetchFailure
    case deleteFailure
}

protocol CoreDataManagable {
    func save(_ info: GyroInformationModel) throws
    func fetch() throws -> [GyroInformationModel]
    func delete(_ info: GyroInformationModel) throws
}

final class CoreDataManager: CoreDataManagable {
    static let shared: CoreDataManager = CoreDataManager()
    
    private init() {}
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GyroInformation")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("ERROR: fail to load Persistent Stores \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var entity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "GyroInformation", in: context)
    }
    
    private func saveToContext() throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw error
            }
        }
    }
    
    func save(_ info: GyroInformationModel) throws {
        guard let entity = entity else { return }
        
        let managedObject = NSManagedObject(entity: entity,
                                            insertInto: context)
        managedObject.setValue(info.id, forKey: "id")
        managedObject.setValue(info.date, forKey: "date")
        managedObject.setValue(info.time, forKey: "time")
        managedObject.setValue(info.graphMode, forKey: "graphMode")
        
        try? saveToContext()
    }
    
    private func fetchGyroInformation() throws -> [GyroInformation]? {
        let request = GyroInformation.fetchRequest()
        let results = try? context.fetch(request)
        return results
    }
    
    func fetch() throws -> [GyroInformationModel] {
        var gyroInformationModels: [GyroInformationModel] = []
        guard let fetchResults = try? fetchGyroInformation() else {
            return []
        }
        
        for result in fetchResults {
            if let id = result.id {
                let gyroInformationModel = GyroInformationModel(id: id,
                                                                date: result.date,
                                                                time: result.time,
                                                                graphMode: result.graphModeValue)
                
                gyroInformationModels.append(gyroInformationModel)
            }
        }
        return gyroInformationModels
    }
    
    func delete(_ info: GyroInformationModel) throws {
        let fetchResults = try? fetchGyroInformation()
        guard let infoItem = fetchResults?.filter({ $0.id == info.id }).first else { return }
        
        context.delete(infoItem)
        try? saveToContext()
    }
}
