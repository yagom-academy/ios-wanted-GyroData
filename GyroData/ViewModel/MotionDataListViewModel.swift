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
        case view(at: IndexPath, closure: (MotionDataDetailViewModel) -> Void)
        case play(at: IndexPath, closure: (MotionDataDetailViewModel) -> Void)
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
            createNewMotionData(closure)
        case let .view(indexPath, closure):
            let data = fetchMotionData(at: indexPath)
            showMotionData(data, closure)
            break
        case let .play(indexPath, closure):
            let data = fetchMotionData(at: indexPath)
            showMotionData(data, closure)
            break
        case let .delete(indexPath):
            delete(at: indexPath)
            break
        case .scrollToBottom:
            updateMotionData()
            break
        }
    }
    
    private func createNewMotionData(_ closure: @escaping (RecordMotionDataViewModel) -> Void) { }
    
    private func showMotionData(_ data: MotionData, _ closure: @escaping (MotionDataDetailViewModel) -> Void) { }
    
    // 코어데이터에서 10개씩 꺼내오는 메서드
    private func updateMotionData() { }
    
    private func add(_ data: MotionData) {
        motionData.append(data)
    }
    
    private func numberOfData() -> Int {
        return motionData.count
    }
    
    private func fetchMotionData(at indexPath: IndexPath) -> MotionData {
        return MotionData(motionDataType: .accelerometer)
    }
    
    private func delete(at indexPath: IndexPath) { }
}
