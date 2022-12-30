//
//  MotionCoreDataUseCase.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/28.
//

import Foundation
import CoreData

class MotionCoreDataUseCase {
    let coreDataManager = CoreDataManager()
    
    func save(item: Motion, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        let motionInfo = MotionInfo(
            entity: MotionInfo.entity(),
            insertInto: coreDataManager.coreDataStack?.managedContext
        )
        motionInfo.id = item.id
        motionInfo.motionType = item.motionType.rawValue
        motionInfo.date = item.date
        motionInfo.time = item.time
        
        coreDataManager.save(completion: completion)
    }

    func delete(id: UUID, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: MotionInfo.Constant.entitiyName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)

        coreDataManager.delete(fetchRequest, completion: completion)
    }
    
    func fetch(offset: Int, count: Int) -> [Motion]? {
        let fetchRequest = MotionInfo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: MotionInfo.Constant.date, ascending: false)]
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = count
        
        let motions = coreDataManager.fetch(fetchRequest)
        
        return motions?.map { Motion(model: $0) }
    }
}
