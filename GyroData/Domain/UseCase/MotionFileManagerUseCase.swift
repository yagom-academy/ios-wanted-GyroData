//
//  MotionFileManagerUseCase.swift
//  GyroData
//
//  Created by Judy on 2022/12/29.
//

import Foundation

class MotionFileManagerUseCase {
    private let fileDataManager = FileDataManager.shared
    
    func save(_ motion: Motion, motinData: [[Double]], completion: @escaping (Result<Void, FileManagerError>) -> Void) {
        let xData = motinData.map { $0[MotionData.x.rawValue] }
        let yData = motinData.map { $0[MotionData.y.rawValue] }
        let zData = motinData.map { $0[MotionData.z.rawValue] }
        let motionInformation = MotionInformation(motion: motion, xData: xData, yData: yData, zData: zData)
        
        fileDataManager.save(motionInformation, id: motion.id, completion: completion)
    }
    
    func fetch(_ id: UUID, completion: @escaping (Result<Void, FileManagerError>) -> Void) -> MotionInformation? {
        return fileDataManager.fetch(id, completion: completion)
    }
    
    func delete(_ id: UUID, completion: @escaping (Result<Void, FileManagerError>) -> Void) {
        fileDataManager.delete(id, completion: completion)
    }
}
