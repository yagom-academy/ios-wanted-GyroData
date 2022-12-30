//
//  FileManager.swift
//  GyroData
//
//  Created by 천승희 on 2022/12/30.
//

import Foundation

class FileManagerService {
    static var shared = FileManagerService()
    
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func saveMeasureFile(data: MeasureValue) throws {
        let jsonEncoder = JSONEncoder()
        
        do {
            let encodeData = try jsonEncoder.encode(data)
            let fileURL = documentURL.appending(path: data.measureDate + ".json")
            
            do {
                try encodeData.write(to: fileURL)
            } catch {
                throw FileError.writeError
            }
        } catch {
            throw FileError.encodeError
        }
    }
    
    func loadMeasureFile(fileName: String) -> Data? {
        let url = URL(fileURLWithPath: fileName + ".json", relativeTo: self.documentURL)

        do {
            let data:Data = try Data(contentsOf: url)

            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteMeasureFile(fileName: String) {
        let fileURL = documentURL.appendingPathComponent("\(fileName).json")
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error)
        }
    }
    
    func parseJSON(with jsonData: Data) -> MeasureValue? {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(MeasureValue.self, from: jsonData)
            
            return decodeData
        } catch {
            return nil
        }
    }
    
    func getMeasureInfo(key: String) -> MeasureValue? {
        guard let jsonFile = loadMeasureFile(fileName: key), let measureInfo = parseJSON(with: jsonFile) else{
            return nil
        }
        
        return measureInfo
    }
}
