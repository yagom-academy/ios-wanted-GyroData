//
//  MotionManagerable.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/03.
//

import Foundation

protocol MotionManagerable {
    func start(handler: @escaping (MotionCoordinate) -> Void)
    func stop()
}
