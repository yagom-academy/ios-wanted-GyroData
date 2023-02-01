//
//  MotionCreatable.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol MotionCreatable {
    associatedtype T: CoreDataRepository
    associatedtype U: FileManagerRepository
    
    var coreDataRepository: T { get }
    var fileManagerRepository: U { get }
    
    func create(date: String, type: Int, time: String, data: [MotionDataType], completion: @escaping (Bool) -> Void)
}
