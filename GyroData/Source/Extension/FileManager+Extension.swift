//  GyroData - FileManager+Extension.swift
//  Created by zhilly, woong on 2023/02/04

import Foundation

extension FileManager {
    
    func add(fileName: String, fileManagedData: FileManagedData) {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
        var filePath = URL(fileURLWithPath: path)
        guard let jsonData = encodeFileManagerData(data: fileManagedData) else { return }
        let appendPathJsonComponent = fileName + ".json"
        
        filePath.appendPathComponent(appendPathJsonComponent)
        self.createFile(atPath: filePath.path,
                        contents: jsonData)
        print(path)
    }
    
    private func encodeFileManagerData(data: FileManagedData) -> Data? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try jsonEncoder.encode(data)
            return jsonData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
