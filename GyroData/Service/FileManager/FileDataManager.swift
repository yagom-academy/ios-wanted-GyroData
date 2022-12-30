//
//  FileDataManager.swift
//  GyroData
//
//  Created by Judy on 2022/12/29.
//

import Foundation

protocol FileDataManagable {
    func save<T: Codable>(_ file: T, id: UUID)
    func delete(_ id: UUID)
    func fetch<T: Codable>(_ id: UUID) -> T?
}

class FileDataManager: FileDataManagable {
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
    
    func save<T: Codable>(_ file: T, id: UUID) {
        let path = directoryPath.appendingPathComponent("\(id).json")
        
        if let data = try? JSONEncoder().encode(file) {
            do {
                try data.write(to: path)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func delete(_ id: UUID) {
        let path = directoryPath.appendingPathComponent("\(id).json")
        
        do {
            try fileManager.removeItem(at: path)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetch<T: Codable>(_ id: UUID) -> T? {
        let path = directoryPath.appendingPathComponent("\(id).json")
        
        do {
            let dataFromPath = try Data(contentsOf: path)
            let fetchedData = try? JSONDecoder().decode(T.self, from: dataFromPath)
            return fetchedData
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
