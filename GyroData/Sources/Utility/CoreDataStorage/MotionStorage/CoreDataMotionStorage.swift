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
    
    func fetch(page: UInt) -> [MotionEntity] {
        let context = coreDataStorage.persistentContainer.viewContext
        let object = try? coreDataStorage.getMotion(context, page: page)
        return object ?? []
    }
    
    func insert(_ motion: Motion) {
        let context = coreDataStorage.persistentContainer.viewContext
        _ = MotionEntity(motion: motion, context: context)
        context.saveContext()
    }
    
    func delete(_ item: MotionEntity) {
        let context = coreDataStorage.persistentContainer.viewContext
        context.delete(item)
        context.saveContext()
        
    }
    
}
