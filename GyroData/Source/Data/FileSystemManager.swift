//
//  FileSystemManager.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/30.
//

import Foundation

final class FileSystemManager {
    private enum FileConstant {
        static let directoryName = "Sensor_JSON_Folder"
        static let jsonExtensionName = ".json"
    }
    
    private let fileManager = FileManager.default
    private let documentPath: URL
    private let directoryPath: URL
    
    init() {
        documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[.zero]
        directoryPath = documentPath.appendingPathComponent(FileConstant.directoryName)
        createDirectory()
    }
    
    private func createDirectory() {
        guard !fileManager.fileExists(atPath: directoryPath.path) else { return }
        try? fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: false)
    }
    
    private func convertJSON(from data: MeasureData) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        
        guard let data = try? encoder.encode(data) else { return nil }
        return data
    }
}

extension FileSystemManager: FileManageable {
    func save(_ data: MeasureData) throws {
        let dataPath = directoryPath.appendingPathComponent(
            data.date.description + FileConstant.jsonExtensionName
        )
        
        guard let data = convertJSON(from: data) else {
            throw FileSystemError.encodeError
        }
        
        do {
            try data.write(to: dataPath)
        } catch {
            throw FileSystemError.saveError
        }
    }
    
    func fetch(date: Date) throws -> Data {
        let dataPath = directoryPath.appendingPathComponent(
            date.description + FileConstant.jsonExtensionName
        )
        
        do {
            let data = try Data(contentsOf: dataPath)
            return data
        } catch {
            throw FileSystemError.loadError
        }
    }
    
    func delete(_ date: Date) throws {
        let dataPath = directoryPath.appendingPathComponent(
            date.description + FileConstant.jsonExtensionName
        )
        
        do {
            try fileManager.removeItem(at: dataPath)
        } catch {
            throw FileSystemError.deleteError
        }
    }
}
