//
//  MotionCreatable.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol MotionCreatable {
    var coreDataRepository: CoreDataRepository { get }
    var fileManagerRepository: FileManagerRepository { get }
    
    func create(
        date: String,
        type: Int,
        time: String,
        data: [MotionDataType],
        completion: @escaping (Bool) -> Void)
}
