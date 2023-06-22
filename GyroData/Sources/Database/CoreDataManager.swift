//
//  CoreDataManager.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/15.
//

import CoreData

final class CoreDataManager {
    enum Constant {
        static let container = "CoreData"
        static let searchCondition = "identifier == %@"
    }
    
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constant.container)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    private var context: NSManagedObjectContext { persistentContainer.viewContext }
    private var currentOffset = 0
    
    private init() { }
    
    func create<DAO: NSManagedObject & DataAccessObject, DTO: DataTransferObject>(type: DAO.Type, data: DTO) throws where DTO == DAO.DataTransferObject {
        guard let entityName = DAO.entity().name,
              let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }
        
        let storage = DAO(entity: entityDescription, insertInto: context)
        storage.setValues(from: data)
        
        do {
            try context.save()
        } catch {
            throw error
        }
    }
        
    func read<DAO: NSManagedObject & DataAccessObject>(type: DAO.Type, countLimit: Int, sortKey: String) -> [DAO]? {
        guard let entityName = DAO.entity().name else { return nil }
        
        let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: false)
        let fetchRequest = NSFetchRequest<DAO>(entityName: entityName)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = countLimit
        fetchRequest.fetchOffset = currentOffset
        currentOffset += countLimit
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            
            return fetchedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func readAll<DAO: NSManagedObject & DataAccessObject>(type: DAO.Type) -> [DAO]? {
        guard let entityName = DAO.entity().name else { return nil }
        
        let fetchRequest = NSFetchRequest<DAO>(entityName: entityName)
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            
            return fetchedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func deleteAll<DAO: NSManagedObject & DataAccessObject>(type: DAO.Type) {
        guard let entityName = DAO.entity().name else { return }
        
        let fetchRequest = NSFetchRequest<DAO>(entityName: entityName)
        guard let storage = try? context.fetch(fetchRequest) else { return }
        
        storage.forEach { data in
            context.delete(data)
        }
        
        save()
    }
    
    func delete<DAO: NSManagedObject & DataAccessObject, DTO: DataTransferObject>(type: DAO.Type, data: DTO) {
        guard let storage = search(type: type, by: data.identifier) else { return }
        
        context.delete(storage)
        
        save()
    }
    
    private func search<DAO: NSManagedObject & DataAccessObject>(type: DAO.Type, by identifier: UUID) -> DAO? {
        guard let entityName = DAO.entity().name else { return nil }
        
        let fetchRequest = NSFetchRequest<DAO>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: Constant.searchCondition, identifier.uuidString)
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            return fetchedData.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
