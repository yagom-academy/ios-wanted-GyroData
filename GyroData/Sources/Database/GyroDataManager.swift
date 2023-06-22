//
//  GyroDataManager.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import Combine

final class GyroDataManager {
    static let shared = GyroDataManager()
    
    private let paginationUnit = 10
    private let coreDataManager = CoreDataManager.shared
    private let jsonCoder = JSONCoder()
    
    @Published var gyroDataList: [GyroData] = []
    @Published var isNoMoreData = false
    
    private init() {
        readDataListFromCoreData()
        
        jsonCoder.debug()
    }
    
    func create(_ gyroData: GyroData) throws {
        gyroDataList.insert(gyroData, at: 0)
        
        do {
            try coreDataManager.create(type: GyroEntity.self, data: gyroData)
        } catch {
            gyroDataList.removeFirst()
            
            throw error
        }
        
        do {
            try jsonCoder.create(data: gyroData)
        } catch {
            gyroDataList.removeFirst()
            coreDataManager.delete(type: GyroEntity.self, data: gyroData)
            
            throw error
        }
    }
    
    func readDataListFromCoreData() {
        guard let entityList = coreDataManager.read(type: GyroEntity.self,
                                                    countLimit: paginationUnit,
                                                    sortKey: "date") else { return }
        
        isNoMoreData = entityList.isEmpty
        
        let fetchedData = getModels(from: entityList)
        gyroDataList.append(contentsOf: fetchedData)
    }
    
    func read(at index: Int) -> GyroData? {
        guard let selectedData = gyroDataList[safe: index] else { return nil }
        
        return jsonCoder.read(type: GyroData.self, data: selectedData)
    }
    
    func delete(at index: Int) {
        guard let selectedData = gyroDataList[safe: index] else { return }
        
        gyroDataList.removeAll { gyroData in
            gyroData.identifier == selectedData.identifier
        }
        
        coreDataManager.delete(type: GyroEntity.self, data: selectedData)
        
        do {
            try jsonCoder.delete(data: selectedData)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension GyroDataManager {
    private func getModels(from entityList: [GyroEntity]) -> [GyroData] {
        var gyroDataList = [GyroData]()
        
        entityList.forEach { gyroEntity in
            guard let gyroData = getModel(from: gyroEntity) else { return }
            
            gyroDataList.append(gyroData)
        }
        
        return gyroDataList
    }
    
    private func getModel(from entity: GyroEntity) -> GyroData? {
        guard let identifier = entity.identifier,
              let dataType = GyroData.DataType(rawValue: Int(entity.dataTypeRawValue)) else {
            return nil
        }
        
        var gyroData = GyroData(dataType: dataType, identifier: identifier)
        
        gyroData.date = entity.date
        gyroData.duration = entity.duration
        
        return gyroData
    }
}
