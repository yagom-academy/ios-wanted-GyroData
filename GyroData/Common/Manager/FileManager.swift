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

    var message: String {
        switch self {
        case .saveFailure:
            return "저장에 실패하였습니다."
        case .fetchFailure:
            return "파일을 불러오는 것에 실패하였습니다."
        case .deleteFailure:
            return "삭제에 실패하였습니다."
        }
    }
}

protocol FileDataManageable {
    func save<T: Codable>(data: T, id: UUID, completion: @escaping (Result<Void, FileDataManagerError>) -> Void)
    func fetch<T: Codable>(id: UUID, completion: @escaping (Result<Void, FileDataManagerError>) -> Void) -> T?
    func delete(id: UUID, completion: @escaping (Result<Void, FileDataManagerError>) -> Void)
}

final class FileDataManager: FileDataManageable {
    static let shared: FileDataManager = FileDataManager()
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
