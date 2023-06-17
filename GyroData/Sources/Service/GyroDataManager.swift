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
        read()
        
        jsonCoder.debug()
    }
    
    func create(_ gyroData: GyroData) {
        gyroDataList.insert(gyroData, at: 0)
        coreDataManager.create(type: GyroEntity.self, data: gyroData)
        do {
            try jsonCoder.save(data: gyroData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func read() {
        guard let entityList = coreDataManager.read(type: GyroEntity.self,
                                                    countLimit: paginationUnit,
                                                    sortKey: "date") else { return }
        
        isNoMoreData = entityList.isEmpty
        
        let fetchedData = getModels(from: entityList)
        gyroDataList.append(contentsOf: fetchedData)
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
              let dataType = GyroData.DataType(rawValue: Int(entity.dataTypeRawValue)),
              let axisX = entity.axisX,
              let axisY = entity.axisY,
              let axisZ = entity.axisZ else {
            return nil
        }
        
        var gyroData = GyroData(dataType: dataType, identifier: identifier)
        
        for index in 0..<axisX.count {
            guard let x = axisX[safe: index],
                  let y = axisY[safe: index],
                  let z = axisZ[safe: index] else { continue }
            
            let coordinate = Coordinate(x: x, y: y, z: z)
            
            gyroData.coordinateList.append(coordinate)
        }
        
        gyroData.date = entity.date
        gyroData.duration = entity.duration
        
        return gyroData
    }
}
