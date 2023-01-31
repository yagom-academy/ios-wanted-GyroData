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
    
    func save(_ data: MotionData, with fileName: String) throws {
        //
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
    
    private func encode() { }
    
    private func decode() { }
}
