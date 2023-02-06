//
//  MotionDeletable.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol MotionDeletable {
    var coreDataRepository: CoreDataRepository { get }
    var fileManagerRepository: FileManagerRepository { get }
    
    func delete(_ id: String) -> Bool
}
