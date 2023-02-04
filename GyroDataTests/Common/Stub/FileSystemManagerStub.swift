//
//  FileSystemManagerMock.swift
//  GyroDataTests
//
//  Created by Kyo, JPush on 2023/01/31.
//

import Foundation

final class FileSystemManagerStub: FileManageable {
    var data: [Data] = []
    
    func save(_ model: MeasureData) throws {
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(model)
        
        data.append(jsonData)
    }
    
    func fetch(date: Date) throws -> Data {
        return data[.zero]
    }
    
    func delete(_ date: Date) throws {
        let decoder = JSONDecoder()
        
        data = try data.filter({
            let model = try decoder.decode(MeasureData.self, from: $0)
            return model.date != date
        })
    }
}
