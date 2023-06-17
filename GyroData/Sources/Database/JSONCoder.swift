//
//  JSONCoder.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/17.
//

import Foundation

final class JSONCoder {
    static private let encoder = JSONEncoder()
    static private let decoder = JSONDecoder()
    private let filemanager = FileManager.default
    private lazy var documentDirectory = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first
    
    func create<DTO: DataTransferObject & Encodable>(data: DTO) throws {
        do {
            guard let documentDirectory else { return }
            
            let fileURL = documentDirectory.appending(path: "\(data.identifier).json")
            let encodedData = try JSONCoder.encoder.encode(data)
            
            try encodedData.write(to: fileURL)
        } catch {
            throw error
        }
    }
    
    func read<DTO: DataTransferObject & Decodable>(type: DTO.Type, data: DTO) -> DTO? {
        guard let documentDirectory else { return nil }
        
        let fileURL = documentDirectory.appending(path: "\(data.identifier).json")
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        
        let decodedData = try? JSONCoder.decoder.decode(type, from: data)
        
        return decodedData
    }
    
    func delete<DTO: DataTransferObject>(data: DTO) throws {
        guard let documentDirectory else { return }
        
        let fileURL = documentDirectory.appending(path: "\(data.identifier).json")
        
        try? filemanager.removeItem(at: fileURL)
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
