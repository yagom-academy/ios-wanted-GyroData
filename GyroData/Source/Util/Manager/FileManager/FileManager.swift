//
//  FileManager.swift
//  GyroData
//
//  Created by 유한석 on 2022/12/26.
//

import Foundation

protocol MeasureDataSavingInFileManagerProtocol {
    func load(path: String, completion: @escaping (Result<MotionData, Error>) -> Void)
    func save(path: String, to motionData: MotionData, completion: @escaping (Result<Bool, Error>) -> Void)
    func remove(path: String)
}

extension FileManager: MeasureDataSavingInFileManagerProtocol {
    
    enum FileManagerError: Error {
        case loadError
        case saveError
        case directoryError
    }
    
    func load(path: String, completion: @escaping (Result<MotionData, Error>) -> Void) {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(path).json")
        print(fileURL.absoluteString)
        if FileManager.default.fileExists(atPath: fileURL.absoluteString) {
            completion(.failure(FileManagerError.loadError))
            return
        }
        
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            let decodeJson = try jsonDecoder.decode(MotionData.self, from: jsonData)
            completion(.success(decodeJson))
        } catch {
            completion(.failure(FileManagerError.loadError))
        }
    }
    
    func save(path: String, to motionData: MotionData, completion: @escaping (Result<Bool, Error>) -> Void) {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(path).json")
        
        if !FileManager.default.fileExists(atPath: directoryURL.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            } catch {
                completion(.failure(FileManagerError.directoryError))
            }
        }
        print("url is \(fileURL.absoluteString)")
        do {
            let jsonEncoder = JSONEncoder()
            let encodedData = try jsonEncoder.encode(motionData)
            print(String(data: encodedData, encoding: .utf8)!)
            try encodedData.write(to: fileURL)
            completion(.success(true))
        } catch {
            print(error.localizedDescription)
            completion(.failure(FileManagerError.saveError))
        }
    }
    
    func remove(path: String) {
        
    }
}
