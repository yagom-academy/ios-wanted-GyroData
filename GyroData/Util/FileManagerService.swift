//
//  FileManagerService.swift
//  GyroData
//
//  Created by sole on 2022/09/23.
//

import Foundation

final class FileManagerService {
    private let manager: FileManager = FileManager.default
    private let directoryURL: URL = URL.documentsDirectory.appending(path: "MotionData")
    
    func createDirectory() {
        
        do {
            let directoryPath = directoryURL.path()
            guard !manager.fileExists(atPath: directoryPath) else {
                return
            }
            try manager.createDirectory(at: directoryURL, withIntermediateDirectories: false)
        }
        catch {
            print("Fail to create directory - \(error.localizedDescription)")
        }
    }
    
    func saveToJSON(with motionDetailData: [MotionDetailData]) {
        do {
            let encodedData = try JSONEncoder().encode(motionDetailData)
            guard let data = motionDetailData.first else {
                print("Empty Data!")
                return
            }
            let dateString = getFileName(from: data.date)
            let fileURL = directoryURL.appending(path: dateString)
            do {
                try encodedData.write(to: fileURL)
            }
            catch {
                print("Fail to write encodedData - \(error.localizedDescription)")
            }
        }
        catch {
            print("Fail to encode the MotionDetailData - \(error.localizedDescription)")
        }
    }
    
    private func getFileName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        let title = "\(formatter.string(from: date)).json"
        return title
    }
    
    func getDetailDataToFile(with date: Date) -> [MotionDetailData] {
        let jsonDataPath = directoryURL.path() + "/" + getFileName(from: date)
        print(jsonDataPath)
        
        guard manager.fileExists(atPath: jsonDataPath) else {
            print("No File")
            return []
        }
        
        guard let jsonData = manager.contents(atPath: jsonDataPath) else {
            print("json data 없음")
            return []
        }
        
        do {
            let motionDetailDataList = try JSONDecoder().decode([MotionDetailData].self, from: jsonData)
            return motionDetailDataList
        }
        catch {
            print("Fail to decode - \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteData(with date: Date) {
        let filePath = directoryURL.path() + "/" + getFileName(from: date)
        
        do {
            try manager.removeItem(atPath: filePath)
        }
        catch {
            print("Fail to delete - \(error.localizedDescription)")
        }
    }
}
