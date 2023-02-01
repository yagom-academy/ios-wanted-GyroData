//
//  FileManagerProtocol.swift
//  GyroData
//
//  Created by Aejong on 2023/02/01.
//

import Foundation

protocol FileManagerProtocol {
    associatedtype MotionMeasures
    
    func save(fileName: UUID, _ motionMeasures: MotionMeasures, completion: @escaping (Result<Void, Error>) -> Void)
    func load(fileName: UUID) -> MotionMeasures
    func delete(fileName: UUID)
}
