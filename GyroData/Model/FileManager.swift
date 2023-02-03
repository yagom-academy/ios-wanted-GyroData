//
//  FileManager.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import Foundation

final class FileManager {
    
    static var shared = FileManager()
    private let coreDataManager = CoreDataManager()
    private let jsonDataManager = JSONDataManager()
    var motionDataList: [MotionData] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("motionDataChanged"),
                                            object: nil)
        }
    }
    
    private init() {
        updateMotionDataList()
    }
    
    private func updateMotionDataList() {
        motionDataList = coreDataManager.readMotionDataEntity().map { $0.toDomain() }
        jsonDataManager.createJSONData(domainData: motionDataList)
    }
    
    func fetchData() -> [MotionData] {
        return motionDataList
    }
    
    func fetchData(index: Int) -> MotionData {
        return motionDataList[index]
    }
    
    func createMotionData(type: MotionType, time: Double, value: [SIMD3<Double>]) throws {
        let motionData = MotionData(date: Date(),
                                    type: type,
                                    time: time,
                                    value: value,
                                    id: UUID())
        try coreDataManager.create(entity: motionData)
        updateMotionDataList()
    }
    
    func deleteMotionData(index: Int) {
        let motiondata = motionDataList[index]
        coreDataManager.delete(motionDataId: motiondata.id)
        updateMotionDataList()
    }
}
