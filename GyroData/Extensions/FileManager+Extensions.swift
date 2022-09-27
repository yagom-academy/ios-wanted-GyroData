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
        case fetchError
        case incodeError
        case insertError
        case decodeError
        case deleteError
    }
    
    func createDirectory() throws {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsURL.appendingPathComponent("MotionData")
        
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: false, attributes: nil)
        } catch {
            throw FileManagerError.directoryError
        }
    }
    
    func loadMotionFile(name: String) async throws -> MotionFile {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(name).json")
        
        guard FileManager.default.fileExists(atPath: "\(fileURL)") else { throw FileManagerError.directoryError }
        
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            let decodeJson = try jsonDecoder.decode(MotionFile.self, from: jsonData)
            return decodeJson
        } catch {
            throw FileManagerError.decodeError
        }
    }

    func saveMotionFile(file: MotionFile) {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(file.fileName).json")
        
        do {
            let jsonEncoder = JSONEncoder()
            let encodedData = try jsonEncoder.encode(file)
            
            do {
                print(String(data: encodedData, encoding: .utf8)!)
                try encodedData.write(to: fileURL)
            } catch let e as NSError {
                print(e.localizedDescription)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @discardableResult
    func removeMotionFile(name: String) -> Error? {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(name).json")
        
        guard !FileManager.default.fileExists(atPath: "\(fileURL)") else {
            return NSError(domain: "File does not exist", code: -1) as Error
        }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            return error
        }
        
        return nil
    }
}
