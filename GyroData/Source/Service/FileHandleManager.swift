//
//  FileHandleManager.swift
//  GyroData
//
//  Created by Aejong on 2023/02/01.
//

import Foundation

class FileHandleManager: FileManagerProtocol {
    private let fileManager: FileManager = FileManager.default
    private let directoryPath: URL
    
    init?() {
        let libraryPath: URL = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        directoryPath = libraryPath.appendingPathComponent("json")
        do {
            try createFolder()
        } catch {
            return nil
        }
    }
    
    private func createFolder() throws {
        guard !fileManager.fileExists(atPath: directoryPath.path) else { return }
        
        do {
            try fileManager.createDirectory(
                at: directoryPath,
                withIntermediateDirectories: false,
                attributes: nil
            )
        } catch {
            throw FileManagingError.createDirectoryFailed
        }
    }
    
    func save(
        fileName: UUID,
        motionMeasures: MotionMeasures,
        dispatchGroup: DispatchGroup,
        completionHandler: @escaping (Result<Void, FileManagingError>) -> Void
    ) {
        let encoder = JSONEncoder()
        let fileName = fileName.uuidString
        
        DispatchQueue.global().async(group: dispatchGroup) { [weak self] in
            do {
                guard let jsonData = try? encoder.encode(motionMeasures) else {
                    completionHandler(.failure(.encodeFailed))
                    return
                }
                
                guard let jsonPath: URL = self?.directoryPath.appendingPathComponent("\(fileName).json") else { return }
                
                try jsonData.write(to: jsonPath)
                completionHandler(.success(()))
            } catch {
                completionHandler(.failure(.saveFailed))
            }
        }
    }
    
    func load(
        fileName: UUID,
        completion: @escaping (Result<MotionMeasures, FileManagingError>) -> Void
    ) {
        let decoder = JSONDecoder()
        let jsonPath = directoryPath.appendingPathComponent("\(fileName).json")
        
        do {
            let dataFromPath: Data = try Data(contentsOf: jsonPath)
            guard let decodedData = try? decoder.decode(
                MotionMeasures.self,
                from: dataFromPath
            ) else {
                completion(.failure(.decodeFailed))
                return
            }
            completion(.success(decodedData))
            
        } catch {
            completion(.failure(.loadFailed))
        }
    }
    
    func delete(fileName: UUID) throws {
        let jsonPath = directoryPath.appendingPathComponent("\(fileName).json")
        
        do {
            try fileManager.removeItem(at: jsonPath)
        } catch {
            throw FileManagingError.deleteFailed
        }
    }
}

