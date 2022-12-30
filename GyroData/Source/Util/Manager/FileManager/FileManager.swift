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
        let url = makeFileURL(from: path)
        
        if FileManager.default.fileExists(atPath: url.absoluteString) {
            completion(.failure(FileManagerError.loadError))
            return
        }
        
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = try Data(contentsOf: url, options: .mappedIfSafe)
            let decodeJson = try jsonDecoder.decode(MotionData.self, from: jsonData)
            completion(.success(decodeJson))
        } catch {
            completion(.failure(FileManagerError.loadError))
        }
    }
    
    func save(path: String, to motionData: MotionData, completion: @escaping (Result<Bool, Error>) -> Void) {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("MotionData")
        let fileURL = makeFileURL(from: path) // 위 코드랑 중복 없에는 법 고민
        
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
            try encodedData.write(to: fileURL)
            completion(.success(true))
        } catch {
            completion(.failure(FileManagerError.saveError))
        }
    }
    
    func remove(path: String) {
        let url = makeFileURL(from: path)
        
        do {
            try self.removeItem(at: url)
        } catch {
            print(error)
        }
    }
    
    private func makeFileURL(from path: String) -> URL {
        let newPath = path.split(separator: "/").map { String($0) }.joined()
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(newPath).json")
        
        return fileURL
    }
}

//TODO: 그래프 View 범위를 벗어나지 않도록 확인 한번 하기 (7) -> 마지막에 시간 남으면
//TODO: 에러 처리 하기 (3)
//TODO: 폴더 정리하기 (6)
//TODO: 메서드 네이밍 정리 (4)
//TODO: 리드미 작성하기. (*******)
