//
//  FileManager.swift
//  GyroData
//
//  Created by channy on 2022/09/22.
//

import Foundation

extension FileManager {

    func saveMotionFile(file: MotionFile) {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathExtension("MotionData")
        let fileURL = directoryURL.appendingPathExtension(file.fileName)
        
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
    
    func loadMotionFile(name: String) -> MotionFile? {
        let documentURL = self.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathExtension("MotionData3")
        let fileURL = directoryURL.appendingPathExtension(name)
        
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            let decodeJson = try jsonDecoder.decode(MotionFile.self, from: jsonData)
            return decodeJson
        } catch {
            print(error)
            return nil
        }
    }
}
