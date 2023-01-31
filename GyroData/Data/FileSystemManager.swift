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
        do {
            try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: false)
        } catch let error {
            //TODO: - Error Alert
            print(error.localizedDescription)
        }
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

extension FileSystemManager {
    func save(data: MeasureData) -> Result<Void, FileSystemError> {
        let dataPath = directoryPath.appendingPathComponent(
            data.date.description + FileConstant.jsonExtensionName
        )
        
        guard let data = convertJSON(from: data) else {
            return .failure(.encodeError)
        }
        
        do {
            try data.write(to: dataPath)
            return .success(())
        } catch {
            return .failure(.saveError)
        }
    }
    
    func load(date: Date) -> Result<Data, FileSystemError> {
        let dataPath = directoryPath.appendingPathComponent(
            date.description + FileConstant.jsonExtensionName
        )
        
        do {
            let data = try Data(contentsOf: dataPath)
            return .success(data)
        } catch {
            return .failure(.loadError)
        }
    }
    
    func delete(date: Date) -> Result<Void, FileSystemError> {
        let dataPath = directoryPath.appendingPathComponent(
            date.description + FileConstant.jsonExtensionName
        )
        
        do {
            try fileManager.removeItem(at: dataPath)
            return .success(())
        } catch {
            return .failure(.deleteError)
        }
    }
}
