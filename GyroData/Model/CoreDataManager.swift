//
//  CoreDataManager.swift
//  GyroData
//
//  Created by 리지 on 2023/06/13.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() { }
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func create(_ data: SixAxisDataForCoreData) {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: GyroEntity.key, in: context),
              let storage = NSManagedObject(entity: entity, insertInto: context) as? GyroEntity else { return }
        
        setValue(at: storage, data: data)
        save()
    }
    
    func read(by id: UUID) -> GyroEntity? {
        guard let context else { return nil }
        let request = NSFetchRequest<NSManagedObject>(entityName: GyroEntity.key)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let data = try context.fetch(request)
            return data.first as? GyroEntity
        } catch {
            return nil
        }
    }
    
    func readTenPiecesOfData() -> [GyroEntity]? {
        guard let context = context else { return nil }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: GyroEntity.key)
        request.fetchLimit = 10
        
        do {
            let data = try context.fetch(request)
            return data as? [GyroEntity]
        } catch {
            return nil
        }
    }
    
    func delete(by id: UUID) {
        guard let context = context else { return }
        let request: NSFetchRequest<NSFetchRequestResult> = GyroEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(delete)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAll() {
        guard let context = self.context else { return }
        
        let request: NSFetchRequest<NSFetchRequestResult> = GyroEntity.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(delete)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setValue(at target: GyroEntity, data: SixAxisDataForCoreData) {
        target.setValue(data.id, forKey: "id")
        target.setValue(data.date, forKey: "date")
        target.setValue(data.title, forKey: "title")
        target.setValue(data.recordTime, forKey: "recordTime")
    }
    
    private func save() {
        guard let context = context else { return }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
