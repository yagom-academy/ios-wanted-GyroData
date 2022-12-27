//
//  CoreDataManager.swift
//  GyroData
//
//  Created by minsson on 2022/12/27.
//

protocol LocalDatabase {
    func create(data: MeasuredData)
    func read() -> [MeasuredData]
    func delete(data: MeasuredData)
}

final class CoreDataManager: LocalDatabase {
    var data: [MeasuredData] = []
    
    func create(data: MeasuredData) {
        
    }
    
    func read() -> [MeasuredData] {
        return data
    }
    
    func delete(data: MeasuredData) {
        
    }
}
