//
//  MotionFileManagerUseCase.swift
//  GyroData
//
//  Created by Judy on 2022/12/29.
//

import Foundation

final class MotionFileManagerUseCase {
    private let fileDataManager = FileDataManager.shared
    
    func save(_ motion: MotionInformation, motinData: [[Double]], completion: @escaping (Result<Void, FileManagerError>) -> Void) {
        let xData = motinData.map { $0[MotionData.x.rawValue] }
        let yData = motinData.map { $0[MotionData.y.rawValue] }
        let zData = motinData.map { $0[MotionData.z.rawValue] }
        let motionInformation = Motion(information: motion, xData: xData, yData: yData, zData: zData)
        
        fileDataManager.save(motionInformation, id: motion.id, completion: completion)
    }
    
    func fetch(_ id: UUID, completion: @escaping (Result<Void, FileManagerError>) -> Void) -> Motion? {
        return fileDataManager.fetch(id, completion: completion)
    }
    
    func delete(_ id: UUID, completion: @escaping (Result<Void, FileManagerError>) -> Void) {
        fileDataManager.delete(id, completion: completion)
    }
}
