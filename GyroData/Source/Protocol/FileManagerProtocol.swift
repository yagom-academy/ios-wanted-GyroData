//
//  FileManagerProtocol.swift
//  GyroData
//
//  Created by Aejong on 2023/02/01.
//

import Foundation

protocol FileManagerProtocol {
    func save(
        fileName: UUID,
        motionMeasures: MotionMeasures,
        dispatchGroup: DispatchGroup,
        completionHandler: @escaping (Result<Void, FileManagingError>) -> Void)
    func load(fileName: UUID, completion: @escaping (Result<MotionMeasures, FileManagingError>) -> Void)
    func delete(fileName: UUID) throws
}
