//
//  CoreDataManagerMock.swift
//  GyroDataTests
//
//  Created by Kyo, JPush on 2023/01/31.
//

import Foundation

final class CoreDataManagerStub: DataManageable {
    var data: [MeasureData] = []
    
    func save(_ model: MeasureData) throws {
        data.append(model)
    }
    
    func fetch(offset: Int, limit: Int) throws -> [MeasureData] {
        return data
    }
    
    func delete(_ date: Date) throws {
        data = data.filter({ $0.date != date })
    }
}
