//
//  CoreDataProcessible.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/02/01.
//

import CoreData
import UIKit

protocol CoreDataProcessible {
    func readCoreData() -> Result<[Motion], CoreDataError>
    func saveCoreData(motion: MotionDataForm, complete: @escaping () -> Void)
    func deleteDate(id: UUID)
}

extension CoreDataProcessible {
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
        let entity = NSEntityDescription.entity(forEntityName: "Motion", in: context)
        
        if let entity = entity {
            let info = NSManagedObject(entity: entity, insertInto: context)
            info.setValue(motion.title, forKey: "title")
            info.setValue(motion.date, forKey: "date")
            info.setValue(motion.runningTime, forKey: "runningTime")
            info.setValue(motion.jsonData, forKey: "jsonData")
            info.setValue(UUID(), forKey: "id")
            
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Motion")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
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
