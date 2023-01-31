//
//  FileManager.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import Foundation

enum FileDataManagerError: Error {
    case saveFailure
    case fetchFailure
    case deleteFailure
}

protocol FileDataManageable {
    func save<T: Codable>(data: T, id: UUID, completion: @escaping (Result<Void, FileDataManagerError>) -> Void)
    func fetch<T: Codable>(id: UUID, completion: @escaping (Result<Void, FileDataManagerError>) -> Void) -> T?
    func delete(id: UUID, completion: @escaping (Result<Void, FileDataManagerError>) -> Void)
}

final class FileDataManager: FileDataManageable {
    private let fileManager = FileManager.default
    private lazy var documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private lazy var directoryPath = documentPath.appendingPathComponent("CoreMotion")

    private init() {
        if fileManager.fileExists(atPath: directoryPath.pathExtension) == false {
            do {
                try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func save<T: Codable>(data: T, id: UUID, completion: @escaping (Result<Void, FileDataManagerError>) -> Void) {
        let dataPath = directoryPath.appendingPathComponent("\(id).json")

        if let source = try? JSONEncoder().encode(data) {
            do {
                try source.write(to: dataPath)
                completion(.success(()))
            } catch {
                completion(.failure(.saveFailure))
            }

        }
    }

    func fetch<T: Codable>(id: UUID, completion: @escaping (Result<Void, FileDataManagerError>) -> Void) -> T? {
        let dataPath = directoryPath.appendingPathComponent("\(id).json")

        do {
            let jsonData = try Data(contentsOf: dataPath)
            let data = try? JSONDecoder().decode(T.self, from: jsonData)
            completion(.success(()))
            return data
        } catch {
            completion(.failure(.fetchFailure))
        }

        return nil
    }

    func delete(id: UUID, completion: @escaping (Result<Void, FileDataManagerError>) -> Void) {
        let dataPath = directoryPath.appendingPathComponent("\(id).json")

        do {
            try fileManager.removeItem(at: dataPath)
            completion(.success(()))
        } catch {
            completion(.failure(.deleteFailure))
        }
    }
}
