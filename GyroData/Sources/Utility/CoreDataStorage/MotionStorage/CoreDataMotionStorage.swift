//
//  CoreDataMotionStorage.swift
//  GyroData
//
//  Created by Ari on 2022/12/26.
//

import Foundation

final class CoreDataMotionStorage {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
}

extension CoreDataMotionStorage: MotionStorage {
    
    func fetch() -> [MotionEntity] {
        let context = coreDataStorage.persistentContainer.viewContext
        let object = try? coreDataStorage.getMotion(context)
        return object ?? []
    }
    
    func insert(_ motion: Motion) {
        coreDataStorage.performBackgroundTask { context in
            _ = MotionEntity(motion: motion, context: context)
            context.saveContext()
        }
    }
    
    func delete(_ item: MotionEntity) {
        coreDataStorage.performBackgroundTask { context in
            context.delete(item)
            context.saveContext()
        }
    }
    
}
