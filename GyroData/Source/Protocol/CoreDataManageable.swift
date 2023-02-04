//
//  CoreDataManageable.swift
//  GyroData
//
//  Created by inho on 2023/01/31.
//

import CoreData
import UIKit

protocol CoreDataManageable {
    func saveCoreData(
        motionData: MotionData,
        dispatchGroup: DispatchGroup,
        errorHandler: @escaping (CoreDataError) -> Void
    )
    func readCoreData() -> Result<[MotionEntity], CoreDataError>
    func deleteCoreData(motionData: MotionData) throws
}

extension CoreDataManageable {
    func saveCoreData(
        motionData: MotionData,
        dispatchGroup: DispatchGroup,
        errorHandler: @escaping (CoreDataError) -> Void
    ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            errorHandler(.appDelegateError)
            return
        }
        
        let backgroundContext = appDelegate.backgroundContext
        
        dispatchGroup.enter()
        backgroundContext.perform {
            guard let entity = NSEntityDescription.entity(
                forEntityName: Constant.entityName,
                in: backgroundContext
            ) else {
                errorHandler(.saveError)
                return
            }
            
            let object = NSManagedObject(entity: entity, insertInto: backgroundContext)
            
            object.setValue(motionData.duration, forKey: Constant.duration)
            object.setValue(motionData.id, forKey: Constant.id)
            object.setValue(motionData.measuredDate, forKey: Constant.measuredDate)
            object.setValue(motionData.type.rawValue, forKey: Constant.type)
            
            appDelegate.saveContext()
            dispatchGroup.leave()
        }
    }
    
    func readCoreData() -> Result<[MotionEntity], CoreDataError> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return .failure(.appDelegateError)
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<MotionEntity>(entityName: Constant.entityName)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            return .success(result)
        } catch {
            return .failure(.fetchError)
        }
    }
    
    func deleteCoreData(motionData: MotionData) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw CoreDataError.appDelegateError
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<MotionEntity>(entityName: Constant.entityName)
        
        fetchRequest.predicate = NSPredicate(format: Constant.idFormat, motionData.id.uuidString)
        
        guard let result = try? managedContext.fetch(fetchRequest),
              let objectToDelete = result.first
        else {
            throw CoreDataError.fetchError
        }
        
        managedContext.delete(objectToDelete)
        appDelegate.saveContext()
    }
}

private enum Constant {
    static let entityName = "MotionEntity"
    static let measuredDate = "measuredDate"
    static let duration = "duration"
    static let type = "type"
    static let id = "id"
    static let idFormat = "id = %@"
}
