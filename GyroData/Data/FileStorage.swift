//
//  FileManager.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/29.
//

import Foundation

final class FileStorage {
    private let fileManager = FileManager.default
    private lazy var documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private lazy var directoryURL = documentURL.appendingPathComponent("Gyro-Data")

    static let shared = FileStorage()

    private init() {
        if !UserDefaults.standard.bool(forKey: "isFirst") {
            UserDefaults.standard.set(true, forKey: "isFirst")
            makeDirectory()
        }
    }

    func saveFile(motionRecordData: MotionRecordDTO, completion: @escaping (Result<Void, Error>) -> Void) {
        // TODO: ios 16 분기처리 통해 deprecate된 메서드 사용 중지
        let fileURL = directoryURL.appendingPathComponent("\(motionRecordData.id).txt")
        guard let motionRecordJson = try? JSONEncoder().encode(motionRecordData),
              let data = String(data: motionRecordJson, encoding: .utf8) else { return }

        do {
            try data.write(to: fileURL, atomically: true, encoding: .utf8)
            completion(.success(()))
        } catch {
            print(error)
            completion(.failure(error))
        }
    }

    func loadFile(id: UUID, completion: @escaping (Result<MotionRecordDTO, Error>) -> Void) {
        let filePath = directoryURL.appendingPathComponent("\(id).txt")

        do {
            let data = try Data(contentsOf: filePath)
            let jsonData = try JSONDecoder().decode(MotionRecordDTO.self, from: data)
            completion(.success(jsonData))
        } catch {
            print(error)
            completion(.failure(error))
        }
    }

    func deleteFile(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let filePath = directoryURL.appendingPathComponent("\(id).txt")
        do {
            try fileManager.removeItem(at: filePath)
            completion(.success(()))
        } catch {
            print(error)
            completion(.failure(error))
        }
    }


    private func makeDirectory() {
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: false)
        } catch {
            print(error)
        }
    }
}
