//
//  MotionManagerable.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/03.
//

import Foundation

protocol MotionManagerable: CoreDataManageable {
    func start(handler: @escaping (MotionMeasures?) -> Void)
    func stop()
    func save(completionHandler: @escaping () -> Void) throws
}
