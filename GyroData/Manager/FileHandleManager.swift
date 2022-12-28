//
//  FileHandleManager.swift
//  GyroData
//
//  Created by 이원빈 on 2022/12/28.
//

import Foundation

protocol CoreDataManagerDelegate: AnyObject {
    func create(data: SensorData, uuid: UUID)
    func read(uuid: UUID) -> SensorData?
    func delete(uuid: UUID)
}

final class FileHandleManager: CoreDataManagerDelegate {
    private let fileManager = FileManager.default
    private let directoryPath: URL
    
    init() {
        let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        directoryPath = documentPath.appendingPathComponent("JSON_folder")
        createInitialFolder()
    }
    
    private func createInitialFolder() {
        do {
            try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: false)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func create(data: SensorData, uuid: UUID) {
        let textPath: URL = directoryPath.appendingPathComponent("\(uuid).json")
        guard let data = try? JSONEncoder().encode(data) else { return }
        do {
            try data.write(to: textPath)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func read(uuid: UUID) -> SensorData? {
        let textPath: URL = directoryPath.appendingPathComponent("\(uuid).json")
        do {
            let dataFromPath: Data = try Data(contentsOf: textPath)
            let sensorData = try JSONDecoder().decode(SensorData.self, from: dataFromPath)
            return sensorData
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func delete(uuid: UUID) {
        let textPath: URL = directoryPath.appendingPathComponent("\(uuid).json")
        do {
            try fileManager.removeItem(at: textPath)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
