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
    
    var message: String {
        switch self {
        case .saveFailure:
            return "저장에 실패하였습니다."
        case .fetchFailure:
            return "파일을 불러오는 것에 실패하였습니다."
        case .deleteFailure:
            return "삭제에 실패하였습니다."
        }
    }
}

protocol CoreDataManagable {
    func save(_ info: GyroInformationModel, completion: @escaping (Result<Void, CoreDataError>) -> Void)
    func fetch(limit: Int) throws -> [GyroInformationModel]
    func delete(_ info: GyroInformationModel, completion: @escaping (Result<Void, CoreDataError>) -> Void)
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
    
    private var fetchOffset: Int = 0
    
    private func saveToContext(completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        if context.hasChanges {
            do {
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(.saveFailure))
            }
        }
    }
    
    func save(_ info: GyroInformationModel, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        guard let entity = entity else {
            completion(.failure(.saveFailure))
            return
        }
        
        let managedObject = NSManagedObject(entity: entity,
                                            insertInto: context)
        managedObject.setValue(info.id, forKey: "id")
        managedObject.setValue(info.date, forKey: "date")
        managedObject.setValue(info.time, forKey: "time")
        managedObject.setValue(info.graphMode.rawValue, forKey: "graphMode")
        
        saveToContext(completion: completion)
    }
    
    private func fetchAllGyroInformations() throws -> [GyroInformation]? {
        let request = GyroInformation.fetchRequest()
        let results = try? context.fetch(request)
        return results
    }
    
    private func fetchGyroInformations(limit: Int) throws -> [GyroInformation]? {
        let request = GyroInformation.fetchRequest()
        request.fetchOffset = self.fetchOffset
        request.fetchLimit = limit
        let results = try? context.fetch(request)
        
        self.fetchOffset += limit
        return results
    }
    
    func fetch(limit: Int) throws -> [GyroInformationModel] {
        var gyroInformationModels: [GyroInformationModel] = []
        guard let fetchResults = try? fetchGyroInformations(limit: limit) else {
            throw CoreDataError.fetchFailure
        }
        
        for result in fetchResults {
            if let id = result.id {
                let gyroInformationModel = GyroInformationModel(id: id,
                                                                date: result.date ?? Date(),
                                                                time: result.time,
                                                                graphMode: result.graphModeValue)
                
                gyroInformationModels.append(gyroInformationModel)
            }
        }
        return gyroInformationModels
    }
    
    func delete(_ info: GyroInformationModel, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        let fetchResults = try? fetchAllGyroInformations()
        guard let infoItem = fetchResults?.filter({ $0.id == info.id }).first else {
            completion(.failure(.deleteFailure))
            return
        }
        
        context.delete(infoItem)
        saveToContext(completion: completion)
    }
}
