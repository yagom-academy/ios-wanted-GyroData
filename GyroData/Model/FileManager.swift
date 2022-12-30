//
//  FileManager.swift
//  GyroData
//
//  Created by 천승희 on 2022/12/30.
//

import Foundation

class FileManager {
    static let shared = FileManager()
    
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func saveMeasureFile(data: MeasureInfo) throws {
        let jsonEncoder = JSONEncoder()
        
        do {
            let encodeData = try jsonEncoder.encode(data)
            let fileURL = documentURL.appendingPathComponent("\(data.date).json")
            
            guard !FileManager.default.fileExists(atPath: "\(fileURL)") else {
                throw FileManagerError.writeError
            }
            
            do {
                try encodeData.write(to: fileURL)
            } catch {
                throw FileError.writeError
            }
        } catch {
            throw FileError.encodeError
        }
    }
    
    func loadMeasureFile(fileName: String) throws -> Data? {
        let url = URL(fileURLWithPath: "\(fileName).json", relativeTo: documentURL)
        let fileURL = documentURL.appendingPathComponent("\(fileName).json")
        
        guard !FileManager.default.fileExists(atPath: "\(fileURL)") else {
            throw FileManagerError.loadError
        }
        
        do {
            let data: Data = try Data(contentsOf: url)
            
            return data
        } catch {
            throw FileError.loadError
            return nil
        }
    }
    
    func deleteMeasureFile(fileName: String) throws {
        let fileURL = documentURL.appendingPathComponent("\(fileName).json")
        
        guard !FileManager.default.fileExists(atPath: "\(fileURL)") else {
            throw FileManagerError.deleteError
        }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            throw FileError.deleteError
        }
    }
    
    func parseJSON(with JSONData: Data) throws -> MeasureInfo? {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(MeasureInfo.self, from: JSONData)
            
            return decodeData
        } catch {
            throw FileError.parseError
            return nil
        }
    }
    
    func getMeasureInfo(name: String) - > MeasureInfo? {
        guard let JSONFile = loadMeasureFile(fileName: name), let measureInfo = parseJSON(with: JSONFile) else{
            return nil
        }
        
        return measureInfo
    }
}
