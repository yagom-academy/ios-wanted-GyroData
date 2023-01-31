//
//  DataStorage.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

import Foundation

enum DataStorageError: Error {
    case cannotFindDocumentDirectory
    case cannotCreateDirectory
    case cannotReadFile
    case cannotSaveFile
    case cannotDeleteData
    case cannotEncodeData
    case cannotDecodeData
}

final class DataStorage: DataStorageType {
    private let fileManager: FileManagerType
    private let directoryURL: URL
    
    init(fileManager: FileManagerType = FileManager.default, directoryName: String) throws {
        guard let documentDirectory: URL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { throw DataStorageError.cannotFindDocumentDirectory }
        self.fileManager = fileManager
        directoryURL = documentDirectory.appendingPathComponent(directoryName)
        try createDirectory(with: directoryURL)
    }
    
    func read(with fileName: String) throws -> MotionData {
        let url = directoryURL.appendingPathComponent(fileName)
        
        do {
            let data: Data = try Data(contentsOf: url)
            return try decode(data)
        } catch {
            throw DataStorageError.cannotReadFile
        }
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
    
    func delete(with fileName: String) throws {
        let url = directoryURL.appendingPathComponent(fileName)
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            throw DataStorageError.cannotDeleteData
        }
    }
    
    func createDirectory(with url: URL) throws {
        guard !fileManager.fileExists(atPath: url.path) else { return }
        
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
        let encoder: JSONEncoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            return try encoder.encode(data)
        } catch {
            throw DataStorageError.cannotEncodeData
        }
    }
    
    private func decode(_ data: Data) throws -> MotionData {
        let decoder: JSONDecoder = JSONDecoder()
        
        do {
            return try decoder.decode(MotionData.self, from: data)
        } catch {
            throw DataStorageError.cannotDecodeData
        }
    }
}
