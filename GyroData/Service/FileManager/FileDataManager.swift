//
//  FileDataManager.swift
//  GyroData
//
//  Created by Judy on 2022/12/29.
//

import Foundation

protocol FileDataManagable {
    func save<T: Codable>(_ file: T, id: UUID, completion: @escaping (Result<Void, FileManagerError>) -> Void)
    func delete(_ id: UUID, completion: @escaping (Result<Void, FileManagerError>) -> Void)
    func fetch<T: Codable>(_ id: UUID, completion: @escaping (Result<Void, FileManagerError>) -> Void) -> T?
}

final class FileDataManager: FileDataManagable {
    static let shared = FileDataManager()
    private let fileManager = FileManager.default
    private lazy var documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private lazy var directoryPath = documentPath.appendingPathComponent("CoreMotion")
    
    private init() {
        if !fileManager.fileExists(atPath: directoryPath.pathExtension) {
            do {
                try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func save<T: Codable>(
        _ file: T,
        id: UUID,
        completion: @escaping (Result<Void, FileManagerError>) -> Void
    ) {
        let path = directoryPath.appendingPathComponent("\(id).json")
        
        if let data = try? JSONEncoder().encode(file) {
            do {
                try data.write(to: path)
                completion(.success(()))
            } catch {
                completion(.failure(.save))
            }
        }
    }
    
    func delete(
        _ id: UUID,
        completion: @escaping (Result<Void, FileManagerError>) -> Void
    ) {
        let path = directoryPath.appendingPathComponent("\(id).json")
        
        do {
            try fileManager.removeItem(at: path)
            completion(.success(()))
        } catch {
            completion(.failure(.save))
        }
    }
    
    func fetch<T: Codable>(
        _ id: UUID,
        completion: @escaping (Result<Void, FileManagerError>) -> Void
    ) -> T? {
        let path = directoryPath.appendingPathComponent("\(id).json")
        
        do {
            let dataFromPath = try Data(contentsOf: path)
            let fetchedData = try? JSONDecoder().decode(T.self, from: dataFromPath)
            completion(.success(()))
            return fetchedData
        } catch {
            completion(.failure(.fetch))
        }
        
        return nil
    }
}
