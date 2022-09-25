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
    
    func saveFile(_ jsonString: String,_ coverData: Measure) -> Bool {
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("\(coverData.id).json")
        //print(fileURL)
        
        let jsonData = NSString(string: jsonString)
        
        do {
            try jsonData.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
            return true
        }
        catch {
            return false
        }
    }
    
    func loadFile(_ coverData: Measure) -> Bool {
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("\(coverData.id).json")
        
        do {
            let data = try String(contentsOf: fileURL, encoding: .utf8)
            print(data)
            return true
        }
        catch {
            return false
        }
    }
}
