//
//  FileManager.swift
//  GyroData
//
//  Created by Aejong on 2023/02/01.
//

import Foundation

class FileManager: FileManagerProtocol {
    typealias Measures = MotionMeasures
    
    func save(fileName: UUID, _ motionMeasures: MotionMeasures, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func load(fileName: UUID) -> MotionMeasures {
        return MotionMeasures()
    }
    
    func delete(fileName: UUID) {
        
    }
}
