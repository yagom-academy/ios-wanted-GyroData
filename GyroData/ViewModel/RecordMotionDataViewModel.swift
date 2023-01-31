//
//  RecordMotionDataViewModel.swift
//  GyroData
//
//  Created by Jiyoung Lee on 2023/01/31.
//

import Foundation

final class RecordMotionDataViewModel {
    enum Action {
        case changeSegment(selectedSegmentIndex: Int)
        case start
        case stop
        case save
    }
    
    private let motionData: MotionData
    private let coreDataManager: CoreDataManagerType
    private let dataStorage: DataStorageType
    private let motionManager: MotionManagerType
    private var onUpdate: ((Coordinate) -> Void)?
    private var onAdd: ((MotionData) -> Void)?
    
    init(
        motionData: MotionData,
        coreDataManager: CoreDataManagerType = CoreDataManager.shared,
        dataStorage: DataStorageType,
        motionManager: MotionManagerType
    ) {
        self.motionData = motionData
        self.coreDataManager = coreDataManager
        self.dataStorage = dataStorage
        self.motionManager = motionManager
    }
    
    func bindOnUpdate(_ closure: @escaping (Coordinate) -> Void) {
        onUpdate = closure
    }
    
    func bindOnAdd(_ closure: @escaping (MotionData) -> Void) {
        onAdd = closure
    }
    
    func action(_ action: Action) {
        switch action {
        case let .changeSegment(index):
            select(index: index)
        case .start:
            start()
        case .stop:
            stop()
        case .save:
            save()
        }
    }
    
    private func select(index: Int) {
        let type = MotionDataType.allCases[index]
    }
    
    private func start() { }
    
    private func stop() { }
    
    private func save() { }
    
    func segmentControl() -> [String] {
        return MotionDataType.allCases.map { $0.rawValue }
    }
}
