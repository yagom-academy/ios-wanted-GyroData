//
//  FileManager+.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/30.
//

import Foundation

extension FileManager {

    func createAppDirectory() {
        let fileManager = FileManager.default
        let directoryPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("GyroData")
        
        do {
            try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: false)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addFile(for motion: Motion) {
        let fileManager = FileManager.default
        let directoryPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let name = convertFileName(with: motion)
        let filePath = directoryPath.appendingPathComponent("\(name).json")
        
        if let data = try? JSONEncoder().encode(motion) {
            do {
                try data.write(to: filePath)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func load(for motion: Motion) -> Motion? {
        let fileManager = FileManager.default
        let directoryPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let name = convertFileName(with: motion)
        let filePath = directoryPath.appendingPathComponent("\(name).json")
        
        if let data = try? Data(contentsOf: filePath) {
            if let dataToJson = try? JSONDecoder().decode(Motion.self, from: data) {
                return dataToJson
            }
        }
        
        return nil
    }
    
    func delete(for motion: Motion) {
        let fileManager = FileManager.default
        let directoryPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let name = convertFileName(with: motion)
        let filePath = directoryPath.appendingPathComponent("\(name).json")
        
        do {
            try fileManager.removeItem(at: filePath)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func convertFileName(with motion: Motion) -> String {
        return motion.date.filter{ $0.isNumber }
    }
}
