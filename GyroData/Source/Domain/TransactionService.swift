//
//  TransactionService.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/30.
//

import Foundation

final class TransactionService {
    private var list: [MeasureData] = []
    
    private let coreDataManager: CoreDataManager
    private let fileManager: FileSystemManager
    
    init(coreDataManager: CoreDataManager, fileManager: FileSystemManager) {
        self.coreDataManager = coreDataManager
        self.fileManager = fileManager
    }
}

extension TransactionService {
    func dataLoad(offset: Int, limit: Int) -> Result<[MeasureData], Error> {
        do {
            list = try coreDataManager.fetch(offset: offset, limit: limit)
            return .success(list)
        } catch {
            return .failure(error)
        }
        
    }
    
    func jsonDataLoad(date: Date) -> Result<Data, FileSystemError> {
        do {
            let data = try fileManager.fetch(date: date)
            return .success(data)
        } catch {
            return .failure(.loadError)
        }
    }
    
    func save(data: MeasureData) -> Error? {
        do {
            try fileManager.save(data)
            try coreDataManager.save(data)
            return nil
        } catch {
            return error
        }
    }
    
    func delete(date: Date) -> Error? {
        do {
            try coreDataManager.delete(date)
            try fileManager.delete(date)
            return nil
        } catch {
            return error
        }
    }
}
