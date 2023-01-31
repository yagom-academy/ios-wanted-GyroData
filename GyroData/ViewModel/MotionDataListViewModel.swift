//
//  MotionDataListViewModel.swift
//  GyroData
//
//  Created by Jiyoung Lee on 2023/01/31.
//

import Foundation

final class MotionDataListViewModel {
    enum Action {
        case recordButtonTapped(closure: (RecordMotionDataViewModel) -> Void)
        case view(at: IndexPath)
        case play(at: IndexPath)
        case delete(at: IndexPath)
        case scrollToBottom
    }
    
    private var motionData: [MotionData] = []
    private let coreDataManager: CoreDataManagerType
    private var onUpdate: (() -> Void)?
    private let pagingLimit = 10
    private var currentDataIndex = 0
    
    init(coreDataManager: CoreDataManagerType = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func action(_ action: Action) {
        switch action {
        case let .recordButtonTapped(closure):
            createRecordMotionDataViewModel(closure)
        case let .view(indexPath):
            break
        case let .play(indexPath):
            break
        case let .delete(indexPath):
            break
        case .scrollToBottom:
            break
        }
    }
    
    private func updateMotionData() { }
    
    private func add(_ data: MotionData) { }
    
    private func numberOfData() -> Int {
        return motionData.count
    }
    
    private func fetchMotionData(at indexPath: IndexPath) -> MotionData {
        return MotionData(motionDataType: .accelerometer)
    }
    
    private func createRecordMotionDataViewModel(_ closure: @escaping (RecordMotionDataViewModel) -> Void) { }
}
