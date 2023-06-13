//
//  CoreDataManager.swift
//  GyroData
//
//  Created by 리지 on 2023/06/13.
//

import UIKit
import CoreData

final class CoreDataManager<T: NSManagedObject & EntityKeyProtocol> {
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func create(_ data: SixAxisData) {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: T.key, in: context),
              let storage = NSManagedObject(entity: entity, insertInto: context) as? T else { return }
        
        setValue(at: storage, data: data)
        save()
    }
    
    func readTenPiecesOfData() -> [T]? {
        guard let context = context else { return nil }
        let request = NSFetchRequest<T>(entityName: T.key)
        request.fetchLimit = 10
        
        do {
            let data = try context.fetch(request)
            return data
        } catch {
            return nil
        }
    }
    
    func delete(by id: UUID) {
        guard let context = context else { return }
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(delete)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setValue(at target: T, data: SixAxisData) {
        if target is GyroEntity {
            target.setValue(data.id, forKey: "id")
            target.setValue(data.date, forKey: "date")
            target.setValue(data.title, forKey: "title")
            target.setValue(data.record, forKey: "record")
        }
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
