//
//  MotionFileManager.swift
//  GyroData
//
//  Created by Ari on 2022/12/26.
//

import Foundation

final class MotionFileManager {
    
    let shared = MotionFileManager()
    private init() {}
    
    private let manager: FileManager = FileManager.default
    private let documentURL: URL = {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentURL.appending(path: "MotionData")
    }()
    
}

extension MotionFileManager {
    
    func save(data: Motion) throws {
        if manager.fileExists(atPath: documentURL.absoluteString) == false {
            do {
                try manager.createDirectory(at: documentURL, withIntermediateDirectories: true)
            } catch {
                debugPrint(error)
                throw MotionFileManagerError.badSave
            }
        }
        do {
            let encoder = JSONEncoder()
            let newFileURL = documentURL.appending(path: data.uuid.uuidString + ".json")
            let data = try encoder.encode(data)
            try data.write(to: newFileURL)
        } catch {
            debugPrint(error)
            throw MotionFileManagerError.badSave
        }
    }
    
    func load(by uuid: UUID) throws -> Motion {
        let fileURL = documentURL.appending(path: uuid.uuidString + ".json")
        guard manager.fileExists(atPath: fileURL.absoluteString) == false else {
            throw MotionFileManagerError.notFound
        }
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: fileURL)
            let motion = try decoder.decode(Motion.self, from: data)
            return motion
        } catch {
            debugPrint(error)
            throw MotionFileManagerError.notFound
        }
    }
    
    func delete(by uuid: UUID) throws {
        let fileURL = documentURL.appending(path: uuid.uuidString + ".json")
        guard manager.fileExists(atPath: fileURL.absoluteString) == false else {
            throw MotionFileManagerError.badDelete
        }
        do {
            try manager.removeItem(at: fileURL)
        } catch {
            debugPrint(error)
            throw MotionFileManagerError.badDelete
        }
    }
}

enum MotionFileManagerError: LocalizedError {
    
    case notFound
    case badSave
    case badDelete
    
    var errorDescription: String? {
        switch self {
        case .notFound: return "파일을 찾을 수 없습니다."
        case .badSave: return "알 수 없는 이유로 저장에 실패하였습니다."
        case .badDelete: return "알 수 없는 이유로 제거에 실패하였습니다."
        }
    }
    
}
