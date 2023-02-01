//
//  DataStorage.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

import Foundation

final class DataStorage: DataStorageType {
    private let fileManager: FileManagerType
    private let directoryURL: URL
    
    init(fileManager: FileManagerType = FileManager.default, directoryName: String) throws {
        guard let documentDirectory = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { throw DataStorageError.cannotFindDocumentDirectory }
        
        self.fileManager = fileManager
        directoryURL = documentDirectory.appendingPathComponent(directoryName)
        try createDirectory(with: directoryURL)
    }
    
    func read(_ fileName: String) -> MotionData? {
        let url = directoryURL.appendingPathComponent(fileName + FileType.json)
        let data = try? Data(contentsOf: url)
        return decode(data)
    }
    
    func save(_ data: MotionData) throws {
        let url = directoryURL.appendingPathComponent(data.id.description)
        let jsonData = try encode(data)
        
        do {
            try jsonData.write(to: url)
        } catch {
            throw DataStorageError.cannotSaveFile
        }
    }
    
    func delete(_ fileName: String) {
        let url = directoryURL.appendingPathComponent(fileName + FileType.json)
        try? fileManager.removeItem(at: url)
    }
    
    private func createDirectory(with url: URL) throws {
        guard fileManager.fileExists(atPath: url.path) == false else { return }
        
        do {
            try fileManager.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            throw DataStorageError.cannotCreateDirectory
        }
    }
    
    private func encode(_ data: MotionData) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            return try encoder.encode(data)
        } catch {
            throw DataStorageError.cannotEncodeData
        }
    }
    
    private func decode(_ data: Data?) -> MotionData? {
        guard let data = data else { return nil }
        return try? JSONDecoder().decode(MotionData.self, from: data)
    }
}
