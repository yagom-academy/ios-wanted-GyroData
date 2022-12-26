//
//  MotionStorage.swift
//  GyroData
//
//  Created by Ari on 2022/12/26.
//

import Foundation

protocol MotionStorage {
    
    func fetch() -> [MotionEntity]
    func insert(_ motion: Motion)
    func delete(_ item: MotionEntity)
    
}
