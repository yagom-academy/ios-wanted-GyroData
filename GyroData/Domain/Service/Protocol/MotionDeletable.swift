//
//  MotionDeletable.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol MotionDeletable {
    associatedtype T: CoreDataRepository
    associatedtype U: FileManagerRepository
    
    var coreDataRepository: T { get }
    var fileManagerRepository: U { get }
    
    func delete(_ id: String) -> Bool
}
