//
//  MeasureFileManager.swift
//  GyroData
//
//  Created by 신동원 on 2022/09/25.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class MeasureFileManager {
    
    static let shared = MeasureFileManager()
    let fileManager = FileManager.default
    
    //파일 쓰기
    func saveFile(_ jsonString: String,_ coverData: Measure) -> Bool {
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("\(coverData.id).json")
        
        let jsonData = NSString(string: jsonString)
        
        do {
            try jsonData.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
            return true
        }
        catch {
            return false
        }
    }
    
    //파일 읽기
    func loadFile(id: String) -> Result<[GyroJson], Error> {
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("\(id).json")
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let decodeData = try decoder.decode([GyroJson].self, from: data)
            return .success(decodeData)
        }
        catch let error {
            return .failure(error)
        }
    }
}
