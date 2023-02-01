//
//  FileManagerProtocol.swift
//  GyroData
//
//  Created by Aejong on 2023/02/01.
//

import Foundation

protocol FileManagerProtocol {
    func save(fileName: UUID, _ motionMeasures: MotionMeasures) throws
    func load(fileName: UUID, completion: @escaping (Result<MotionMeasures, FileManagingError>) -> Void)
    func delete(fileName: UUID) throws
}
