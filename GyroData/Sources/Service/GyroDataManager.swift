//
//  GyroDataManager.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import Combine

final class GyroDataManager {
    static let shared = GyroDataManager()
    
    private let coreDataManager = CoreDataManager.shared
    
    @Published var gyroDataList: [GyroData] = []
    @Published var isLastData = false
    
    private init() {
        read()
    }
    
    func create(_ gyroData: GyroData) {
        gyroDataList.insert(gyroData, at: 0)
        coreDataManager.create(type: GyroEntity.self, data: gyroData)
    }
    
    func read() {
        guard let entityList = coreDataManager.read(type: GyroEntity.self,
                                                    countLimit: 10,
                                                    sortKey: "date") else { return }
        
        if entityList.isEmpty {
            isLastData = true
            
            return
        }
        
        let fetchedData = getModels(from: entityList)
        gyroDataList.append(contentsOf: fetchedData)
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
            let coordinate = Coordinate(x: axisX[index],
                                        y: axisY[index],
                                        z: axisZ[index])
            
            gyroData.coordinateList.append(coordinate)
        }
        
        gyroData.date = entity.date
        gyroData.duration = entity.duration
        
        return gyroData
    }
}
