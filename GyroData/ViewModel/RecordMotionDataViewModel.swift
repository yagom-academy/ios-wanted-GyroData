//
//  RecordMotionDataViewModel.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

import Foundation

final class RecordMotionDataViewModel {
    enum Action {
        case changeSegment(selectedIndex: Int)
        case start
        case stop
        case save
    }
    
    private var motionData: MotionData
    private let coreDataManager: CoreDataManagerType
    private var dataStorage: DataStorageType?
    private let motionManager: MotionManagerType
    private var onUpdate: ((Coordinate) -> Void)?
    private var onAdd: ((MotionData) -> Void)?
    
    init(
        motionDataType: MotionDataType,
        coreDataManager: CoreDataManagerType = CoreDataManager.shared,
        motionManager: MotionManagerType = MotionManager()
    ) {
        motionData = MotionData(motionDataType: motionDataType)
        self.coreDataManager = coreDataManager
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
        print(index)
        let type = MotionDataType.allCases[index]
        motionData.motionDataType = type
        
    }
    
    private func start() { }
    
    private func stop() { }
    
    private func save() { }
    
    func motionDataTypes() -> [String] {
        return MotionDataType.allCases.map { $0.rawValue }
    }
}
