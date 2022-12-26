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
    
    private let manager = FileManager.default
    private let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
}

extension MotionFileManager {
    
    func save(data: Motion) throws {
        do {
            let encoder = JSONEncoder()
            let newFileURL = documentURL.appending(path: data.uuid.uuidString + ".json")
            let json = try encoder.encode(data)
            try json.write(to: newFileURL)
        } catch {
            debugPrint(error)
            throw MotionFileManagerError.badSave
        }
    }
    
    func load(by uuid: UUID) throws -> Motion {
        do {
            let decoder = JSONDecoder()
            let fileURL = documentURL.appending(path: uuid.uuidString + ".json")
            let data = try Data(contentsOf: fileURL)
            let motion = try decoder.decode(Motion.self, from: data)
            return motion
        } catch {
            debugPrint(error)
            throw MotionFileManagerError.notFound
        }
    }
    
    func delete(by uuid: UUID) throws {
        do {
            let fileURL = documentURL.appending(path: uuid.uuidString + ".json")
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
