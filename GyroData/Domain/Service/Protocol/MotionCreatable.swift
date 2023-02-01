//
//  MotionCreatable.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

protocol MotionCreatable {
    var coreDataRepository: any CoreDataRepository { get }
    var fileManagerRepository: any FileManagerRepository { get }
    
    func create(date: Date, type: Int, data: MotionDataType, completion: @escaping (Bool) -> Void)
}
