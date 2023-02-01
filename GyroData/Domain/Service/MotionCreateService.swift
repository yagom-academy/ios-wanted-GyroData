//
//  MotionCreateService.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

struct MotionCreateService<T: CoreDataRepository,
                           U: FileManagerRepository>: MotionCreatable where T.Domain == Motion,
                                                                            T.Entity == MotionMO,
                                                                            U.Domain == Motion,
                                                                            U.Entity == MotionDTO {
    let coreDataRepository: T
    let fileManagerRepository: U
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }()
    
    func create(date: String, type: Int, time: String, data: [MotionDataType], completion: @escaping (Bool) -> Void) {
    }
}
