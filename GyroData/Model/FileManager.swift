//
//  FileManager.swift
//  GyroData
//
//  Created by leewonseok on 2023/02/01.
//

import Foundation


extension FileManager {
    func save(path: String, data: [Coordinate]) {
        let documentsDirectory = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsDirectory.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(path).json")

        do {
            if !self.fileExists(atPath: directoryURL.path) {
                try self.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                print("Directory created at:", directoryURL.path)
            } else {
                print("Directory already exists at:", directoryURL.path)
            }
            
            let data = try JSONEncoder().encode(data)
            try data.write(to: fileURL)
        } catch {
            //에러 처리
        }
    }
    
    func load(path:String) -> [Coordinate]? {
        let documentsDirectory = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsDirectory.appendingPathComponent("MotionData")
        let fileURL = directoryURL.appendingPathComponent("\(path).json")
        
        do {
            let fileData = try Data(contentsOf: fileURL)
            let data = try JSONDecoder().decode([Coordinate].self, from: fileData)
            
            return data
        } catch {
            //에러처리
            return nil
        }
    }
}
