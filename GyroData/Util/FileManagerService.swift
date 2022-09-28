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
    
    func write(_ value: MotionData) throws {
        if !manager.fileExists(atPath: directoryURL.relativePath) {
            try manager.createDirectory(at: directoryURL, withIntermediateDirectories: false)
        }
        let fileURL = composeURL(from: value.date, withExtension: "json")
        let data = try JSONEncoder().encode(value)
        try data.write(to: fileURL)
    }
    
    func read(with date: Date, completion: @escaping (Result<MotionData, Error>) -> Void) {
        do {
            let fileURL = composeURL(from: date, withExtension: "json")
            guard let data = manager.contents(atPath: fileURL.relativePath) else {
                throw FileManagerServiceError.fileNotFound(name: fileURL.relativePath)
            }
            let result = try JSONDecoder().decode(MotionData.self, from: data)
            completion(.success(result))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    func delete(_ date: Date) throws {
        let fileURL = composeURL(from: date, withExtension: "json")
        try manager.removeItem(atPath: fileURL.relativePath)
    }

    private func composeURL(from date: Date, withExtension pathExtension: String) -> URL {
        return directoryURL
            .appendingPathComponent(fileName(from: date))
            .appendingPathExtension(pathExtension)
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
