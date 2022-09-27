//
//  FileManager.swift
//  GyroData
//
//  Created by channy on 2022/09/22.
//

import Foundation

extension FileManager {
    
    enum FileManagerError: Error {
        case directoryError
        case loadError
        case saveError
        case deleteError
    }
    
    func loadMotionFile(name: String) async throws -> MotionFile {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(name).json")
        
        guard !FileManager.default.fileExists(atPath: "\(fileURL)") else { throw FileManagerError.loadError }
        
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            let decodeJson = try jsonDecoder.decode(MotionFile.self, from: jsonData)
            return decodeJson
        } catch {
            throw FileManagerError.loadError
        }
    }

    func saveMotionFile(file: MotionFile) async throws {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(file.fileName).json")
        var isDir: ObjCBool = true
        
        if !FileManager.default.fileExists(atPath: "\(directoryURL)", isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            } catch {
                throw FileManagerError.directoryError
            }
        }
        
        do {
            let jsonEncoder = JSONEncoder()
            let encodedData = try jsonEncoder.encode(file)
            print(String(data: encodedData, encoding: .utf8)!)
            try encodedData.write(to: fileURL)
            return
        } catch {
            throw FileManagerError.saveError
        }
    }
    
    @discardableResult
    func removeMotionFile(fileName name: String) async throws -> Bool {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(name).json")
        
        guard !FileManager.default.fileExists(atPath: "\(fileURL)") else {
            throw FileManagerError.deleteError
        }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            return true
        } catch {
            throw FileManagerError.deleteError
        }
    }
}
