//
//  SystemFileManager.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

class SystemFileManager {
    private let manager = FileManager.default
    
    func saveData<T: Codable>(fileName: String, value: T) -> Bool {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let path = createFilePath(with: fileName) else {
            return false
        }
        
        guard let encodeData = try? encoder.encode(value) else {
            return false
        }
        
        guard let _ = try? encodeData.write(to: path) else {
            return false
        }
        
        return true
    }
    
    func readData<T: Codable>(
        fileName: String,
        type: T.Type,
        completion: @escaping (Result<T, FileReadError>) -> Void
    ) {
        guard let path = createFilePath(with: fileName) else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let data = try? Data(contentsOf: path) else {
            completion(.failure(.decodeData))
            return
        }
        
        guard let decodeData = try? JSONDecoder().decode(T.self, from: data) else {
            completion(.failure(.decodeJson))
            return
        }
        
        completion(.success(decodeData))
    }
    
    func createFilePath(with fileName: String) -> URL? {
        let documentDirectories = manager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = documentDirectories.first else { return nil }
        
        let filePath = documentDirectory.appendingPathComponent(fileName)
        return filePath
    }
}
