//
//  DefaultFileManagerRepository.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

struct DefaultFileManagerRepository: FileManagerRepository {
    private var directory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func create(_ domain: Motion) -> Result<Void, Error> {
        let motionDTO = MotionDTO(from: domain)
        let fileURL = directory.appendingPathComponent("\(motionDTO.id).json")
        do {
            let JSONData = try JSONEncoder().encode(motionDTO)
            try JSONData.write(to: fileURL)
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    func read(with id: String) throws -> MotionDTO {
        let fileURL = directory.appendingPathComponent("\(id).json")
        let JSONData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
        
        return try JSONDecoder().decode(MotionDTO.self, from: JSONData)
    }
    
    func delete(with id: String) throws {
        let fileURL = directory.appendingPathComponent("\(id).json")
        
        try FileManager.default.removeItem(at: fileURL)
    }
}
