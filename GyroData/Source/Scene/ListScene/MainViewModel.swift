//
//  MainViewModel.swift
//  GyroData
//
//  Created by inho on 2023/02/03.
//

import Foundation

final class MainViewModel: CoreDataManageable {
    private let fileHandleManager = FileHandleManager()
    private var motionDatas: [MotionData] = [] {
        didSet {
            self.dataHandler?(motionDatas)
        }
    }
    private var dataHandler: (([MotionData]) -> Void)?
    private(set) var hasNext: Bool = true
    private var coreDataOffset: Int = 0 {
        didSet {
            fetchDatas()
        }
    }
    
    func bindData(_ handler: @escaping (([MotionData]) -> Void)) {
        dataHandler = handler
    }
    
    func saveMotionData(_ data: MotionData) {
            saveCoreData(motionData: data)
            fetchDatas()
    }
    
    func fetchDatas() {
        let fetchResult = readCoreData(offset: coreDataOffset)
        
        switch fetchResult {
        case .success(let motionEntities):
            if motionEntities.count == 0 {
                hasNext = false
                return
            } else {
                hasNext = true
            }
            
            let convertedDatas = motionEntities.compactMap { convertEntityToData($0) }
            let filteredDatas = convertedDatas.filter { !motionDatas.contains($0) }
            
            motionDatas += filteredDatas
        case .failure(let error):
            print(error)
        }
    }
    
    func deleteData(at index: Int) {
        let dataToDelete = motionDatas.remove(at: index)
        
        do {
            try deleteCoreData(motionData: dataToDelete)
            try fileHandleManager?.delete(fileName: dataToDelete.id)
        } catch {
            print(error)
        }
    }
    
    func increaseOffset() {
        coreDataOffset += 10
    }
    
    private func convertEntityToData(_ entity: MotionEntity) -> MotionData? {
        guard let date = entity.measuredDate,
              let typeString = entity.type,
              let type = MotionType(rawValue: typeString),
              let id = entity.id
        else {
            return nil
        }
        
        let motionData = MotionData(
            measuredDate: date,
            duration: entity.duration,
            type: type,
            id: id
        )
        
        return motionData
    }
}
