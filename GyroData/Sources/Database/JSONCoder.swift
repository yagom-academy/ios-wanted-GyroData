//
//  JSONCoder.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/17.
//

import Foundation

final class JSONCoder {
    static private let encoder = JSONEncoder()
    private let filemanager = FileManager.default
    private lazy var documentDirectory = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first
    
    func save<DTO: DataTransferObject & Codable>(data: DTO) throws {
        do {
            guard let documentDirectory,
                  let date = DateFormatter.dateToTextForJSON(data.date) else { return }
            
            let fileURL = documentDirectory.appending(path: "\(date).json")
            let encodedData = try JSONCoder.encoder.encode(data)
            
            try encodedData.write(to: fileURL)
        } catch {
            throw error
        }
    }
    
    func delete<DTO: DataTransferObject & Codable>(data: DTO) throws {
        do {
            guard let documentDirectory,
                  let date = DateFormatter.dateToTextForJSON(data.date) else { return }
            
            let fileURL = documentDirectory.appending(path: "\(date).json")
            
            try filemanager.removeItem(at: fileURL)
        } catch {
            throw error
        }
    }
    
    func debug() {
        do {
            let fileURLs = try filemanager.contentsOfDirectory(at: documentDirectory!, includingPropertiesForKeys: nil)
            
            print("[FileSystem 내 json 파일 목록을 읽어옵니다.]")
            
            for fileURL in fileURLs {
                print("파일: \(fileURL.lastPathComponent)")
            }
        } catch {
            print("파일 목록을 가져오는 중에 오류가 발생했습니다: \(error)")
        }
    }
    
    func deleteAll() {
        guard let documentDirectory = documentDirectory else { return }
        
        guard let fileURLs = try? filemanager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil) else { return }
        
        for fileURL in fileURLs {
            try? filemanager.removeItem(at: fileURL)
        }
    }
}
