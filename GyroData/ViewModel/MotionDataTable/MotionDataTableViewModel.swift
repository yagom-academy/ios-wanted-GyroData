//
//  MotionDataTableViewModel.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import Foundation

final class MotionDataTableViewModel {
    
    private var fileManager: FileManager {
        didSet {
            motionDataListHandler?()
        }
    }
    
    private var motionDataListHandler: (() -> ())?
    
    init() {
        self.fileManager = FileManager.shared
    }
    
    func bindMotionDataList(handler: @escaping () -> ()) {
        self.motionDataListHandler = handler
    }
    
    func fetchMotionDataList() -> [MotionData] {
//        return fileManager.fetchData()
        return [MotionData(date: Date(), type: .accelerometer, time: 15.0, value: [], id: UUID()),
                MotionData(date: Date(), type: .gyro, time: 19.0, value: [], id: UUID()),
                MotionData(date: Date(), type: .accelerometer, time: 35.7, value: [], id: UUID()),]
    }
    
    func fetchMotionData(index: Int) -> MotionData {
        return fileManager.fetchData()[index]
    }
    
    func deleteMotionData(index: Int) {
        fileManager.deleteMotionData(index: index)
    }
}
