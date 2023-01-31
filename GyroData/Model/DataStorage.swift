//
//  DataStorage.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

import Foundation

enum DiskStorageError: Error {
    case cannotFindDocumentDirectory
    case cannotCreateDirectory
    case cannotSaveFile
    case cannotEncodeData
}

final class DataStorage: DataStorageType {
    private let fileManager: FileManagerType
    private let directoryURL: URL
    
    init(fileManager: FileManagerType = FileManager.default, directoryName: String) throws {
        guard let documentDirectory: URL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { throw DiskStorageError.cannotFindDocumentDirectory }
        self.fileManager = fileManager
        directoryURL = documentDirectory.appendingPathComponent(directoryName)
        try createDirectory(with: directoryURL)
    }
    
    func save(_ data: MotionData) throws {
        let url = directoryURL.appendingPathComponent(data.id.description)
        let jsonData = try encode(data)
        
        do {
            try jsonData.write(to: url)
        } catch {
            throw DiskStorageError.cannotSaveFile
        }
    }
    
    func read() {
        //
    }
    
    func delete() {
        //
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
            throw DiskStorageError.cannotCreateDirectory
        }
    }
    
    private func encode(_ data: MotionData) throws -> Data {
        let encoder: JSONEncoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            return try encoder.encode(data)
        } catch {
            throw DiskStorageError.cannotEncodeData
        }
    }
    
    private func decode() { }
}
