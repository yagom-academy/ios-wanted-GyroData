//
//  TransactionService.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/30.
//

import Foundation

final class TransactionService {
    private var list: [MeasureData] = [] {
        didSet {
            dataHandler?(list)
        }
    }
    private var dataHandler: (([MeasureData]) -> Void)?
    
    private let coreDataManager: DataManageable
    private let fileManager: FileManageable

    init(coreDataManager: DataManageable, fileManager: FileManageable) {
        self.coreDataManager = coreDataManager
        self.fileManager = fileManager
    }
    
    func bindData(handler: @escaping (([MeasureData]) -> Void)) {
        dataHandler = handler
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
    
    func save(data: MeasureData, completion: @escaping (Result<Void, Error>) -> Void) {
        let group = DispatchGroup()
        
        DispatchQueue.global().async(group: group) {
            do {
                try self.coreDataManager.save(data)
            } catch {
                return completion(.failure(error))
            }
        }
        
        DispatchQueue.global().async(group: group) {
            do {
                try self.fileManager.save(data)
            } catch {
                return completion(.failure(error))
            }
        }
        
        group.wait()
        self.list.append(data)
        completion(.success(()))
    }
    
    func delete(date: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        let group = DispatchGroup()
        
        DispatchQueue.global().async(group: group) {
            do {
                try self.coreDataManager.delete(date)
            } catch {
                DispatchQueue.main.async {
                    return completion(.failure(error))
                }
            }
        }
        
        DispatchQueue.global().async(group: group) {
            do {
                try self.fileManager.delete(date)
            } catch {
                DispatchQueue.main.async {
                    return completion(.failure(error))
                }
            }
        }
        
        group.wait()
        self.list = self.list.filter({ $0.date != date })
        completion(.success(()))
    }
}
