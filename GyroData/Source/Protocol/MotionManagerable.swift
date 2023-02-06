//
//  MotionManagerable.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/03.
//

import Foundation

protocol MotionManagerable: CoreDataManageable {
    var timeOverHandler: ((Bool) -> Void)? { get set }
    
    func start(handler: @escaping (MotionCoordinate?) -> Void)
    func stop()
    func save(
        completionHandler: @escaping () -> Void,
        errorHandler: @escaping (Error) -> Void
    )
}
