//
//  GraphFileManager.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/28.
//

import Foundation

final class GraphFileManager {
    static let shared = GraphFileManager()
    
    private init() {}
    
    func saveJsonData(data: [GraphModel], fileName: UUID) {
        let jsonEncoder = JSONEncoder()
        
        do {
            let encodedData = try jsonEncoder.encode(data)
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            let fileURL = documentDirectoryUrl.appendingPathComponent("\(fileName).json")
            
            do {
                try encodedData.write(to: fileURL)
            }
            catch let error as NSError {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func loadJsonFile(fileName: UUID) -> [GraphModel]? {
        let jsonDecoder = JSONDecoder()
        
        do {
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
            }
            let fileURL = documentDirectoryUrl.appendingPathComponent("\(fileName).json")
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            let decodedBigSur = try jsonDecoder.decode([GraphModel].self, from: jsonData)
            
            return decodedBigSur
        }
        catch {
            print(error)
            
            return nil
        }
    }
}

