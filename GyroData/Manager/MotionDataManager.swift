//
//  MotionDataManager.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/27.
//

import Foundation
import CoreDataFramework
import CoreData

class MotionDataManager {
    static let shared = MotionDataManager()
    
    private init() { }
    
    func saveMotion(data: GyroModel) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:
                                                                                    "MotionEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", data.id as CVarArg)
        
        let sampleModel = SaveModel(entityName: "MotionEntity",
                                    sampleData: ["id": data.id,
                                                 "coordinate": data.coordinate,
                                                 "createdAt": data.createdAt,
                                                 "motionType": data.motionType])
        CoreDataManager.shared.save(model: sampleModel, request: fetchRequest)
    }
    
    func deleteMotion(id: UUID) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
                            NSFetchRequest(entityName: "MotionEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)

        CoreDataManager.shared.delete(fetchRequest)
    }
    
    func fetchMotion() -> [GyroModel]? {
        guard let data = CoreDataManager.shared.fetch(MotionEntity.fetchRequest()) else {
            return nil
        }
        
        var gyroModel = data.compactMap {
            GyroModel(id: $0.id , coordinate: $0.coordinate,
                      createdAt: $0.createdAt, motionType: $0.motionType)
        }
        
        gyroModel.sort(by: { $0.createdAt > $1.createdAt })
        
        return gyroModel
    }
}
