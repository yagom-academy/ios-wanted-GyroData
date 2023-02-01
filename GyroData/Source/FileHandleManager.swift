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
    
    func save(fileName: UUID, _ motionMeasures: MotionMeasures) throws {
        let encoder = JSONEncoder()
        let fileName = fileName.uuidString
        
        do {
            guard let jsonData = try? encoder.encode(motionMeasures) else {
                throw FileManagingError.encodeFailed
            }
            let textPath: URL = directoryPath.appendingPathComponent("\(fileName).json")
            
            try jsonData.write(to: textPath)
            
        } catch {
            throw FileManagingError.saveFailed
        }
    }
    
    func load(
        fileName: UUID,
        completion: @escaping (Result<MotionMeasures, FileManagingError>) -> Void
    ) {
        let decoder = JSONDecoder()
        let textPath = directoryPath.appendingPathComponent("\(fileName).json")
        
        do {
            let dataFromPath: Data = try Data(contentsOf: textPath)
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
        
    }
}

