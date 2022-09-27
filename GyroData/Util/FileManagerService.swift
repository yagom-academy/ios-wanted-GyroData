//
//  FileManagerService.swift
//  GyroData
//
//  Created by sole on 2022/09/23.
//

import Foundation

final class FileManagerService {
    private let manager: FileManager = FileManager.default
    private let directoryURL: URL = URL.documentsDirectory.appending(path: "MotionData")
    
    func write(_ motionData: GyroData) {
        do {
            try createDirectory()
            let encodedData = try JSONEncoder().encode(motionData)
            let filePath = fileName(from: motionData.date)
            let fileURL = directoryURL.appending(path: filePath)
            try encodedData.write(to: fileURL)
        }
        catch {
            print(#function, error.localizedDescription)
        }
    }
    
    func read(with date: Date) -> GyroData {
        // TODO: 46-47 함수로 빼기
        let fileName = fileName(from: date)
        let filePath = directoryURL.appending(path: fileName).appendingPathExtension("json")
        
        do {
            guard let jsonData = manager.contents(atPath: filePath.relativePath) else {
                throw FileManagerServiceError.fileNotFound(name: fileName)
            }
            let motionData = try JSONDecoder().decode(GyroData.self, from: jsonData)
            return motionData
        }
        catch {
            fatalError(#function + error.localizedDescription)
        }
    }
    
    func delete(_ date: Date) {
        let fileName = fileName(from: date)
        let filePath = directoryURL.appending(path: fileName).appendingPathExtension("json")
        
        do {
            try manager.removeItem(atPath: filePath.relativePath)
        }
        catch {
            print(#function, error.localizedDescription)
        }
    }
    
    private func createDirectory() throws {
        let directoryPath = directoryURL.path()
        if manager.fileExists(atPath: directoryPath) {
            try manager.createDirectory(at: directoryURL, withIntermediateDirectories: false)
        }
    }

    private func fileName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        return formatter.string(from: date)
    }
}

enum FileManagerServiceError: Error {
    case fileNotFound(name: String)
}

extension FileManagerServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            return "File not found - \(name)"
        }
    }
}
