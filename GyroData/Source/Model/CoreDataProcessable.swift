//
//  CoreDataProcessable.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/02/01.
//

import CoreData
import UIKit

protocol CoreDataProcessable {
    func readCoreData() -> Result<[Motion], CoreDataError>
    func saveCoreData(motion: MotionDataForm, complete: @escaping () -> Void)
    func deleteDate(id: UUID)
}

extension CoreDataProcessable {
    func readCoreData() -> Result<[Motion], CoreDataError> {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        do {
            if let contact = try context?.fetch(Motion.fetchRequest()) {
                return .success(contact)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return .failure(.readError)
    }
    
    func saveCoreData(motion: MotionDataForm, complete: @escaping () -> Void) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: NameSpace.entityName, in: context)
        
        if let entity = entity {
            let info = NSManagedObject(entity: entity, insertInto: context)
            
            info.setValue(motion.title, forKey: NameSpace.entityTitle)
            info.setValue(motion.date, forKey: NameSpace.entityDate)
            info.setValue(motion.runningTime, forKey: NameSpace.entityRunningTime)
            info.setValue(motion.jsonData, forKey: NameSpace.entityJsonData)
            info.setValue(UUID(), forKey: NameSpace.entityID)
            
            do {
                try context.save()
                complete()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteDate(id: UUID) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: NameSpace.entityName)
        
        fetchRequest.predicate = NSPredicate(format: NameSpace.idFormat, id as CVarArg)
        
        do {
            let test = try context.fetch(fetchRequest)
            guard let objectDelete = test[0] as? NSManagedObject else { return }
            
            context.delete(objectDelete)
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - NameSpace

private enum NameSpace {
    static let entityName = "Motion"
    static let entityTitle = "title"
    static let entityDate = "date"
    static let entityRunningTime = "runningTime"
    static let entityJsonData = "jsonData"
    static let entityID = "id"
    static let idFormat = "id = %@"
}

