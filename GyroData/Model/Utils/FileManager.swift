//
//  FileManager.swift
//  GyroData
//
//  Created by stone, LJ on 2023/02/01.
//

import Foundation

enum FileManagerError: Error {
    case writeError
}

extension FileManager {
    func save(path: String, data: [Coordinate], completion: @escaping(Result<String, FileManagerError>) -> Void) {
        let documentsDirectory = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsDirectory.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(path).json")

        do {
            if self.fileExists(atPath: directoryURL.path) == false {
                try self.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                print("Directory created at:", directoryURL.path)
            } else {
                print("Directory already exists at:", directoryURL.path)
            }
            
            let data = try JSONEncoder().encode(data)
            try data.write(to: fileURL)
            
            completion(.success(path))
        } catch {
            completion(.failure(.writeError))
        }
    }
    
    func load(path:String) -> [Coordinate]? {
        let documentsDirectory = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsDirectory.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(path).json")
        
        do {
            let fileData = try Data(contentsOf: fileURL)
            let data = try JSONDecoder().decode([Coordinate].self, from: fileData)
            
            return data
        } catch {
            return nil
        }
    }
    
    func delete(path: String) {
        let documentsDirectory = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsDirectory.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(path).json")

        do {
            try self.removeItem(atPath: "\(fileURL)")
        } catch {
            print("remove File Error")
        }
    }
}
