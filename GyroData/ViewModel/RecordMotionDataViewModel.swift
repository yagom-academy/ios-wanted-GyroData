//
//  RecordMotionDataViewModel.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

import Foundation

final class RecordMotionDataViewModel {
    enum Action {
        case changeSegment(to: Int)
        case start(selectedIndex: Int, closure: () -> Void)
        case stop(closure: () -> Void)
    }
    
    enum ThrowableAction {
        case save
    }
    
    private var motionData: MotionData?
    private let coreDataManager: CoreDataManagerType
    private var dataStorage: DataStorageType?
    private let motionManager: MotionManagerType
    private var onUpdate: ((Coordinate) -> Void)?
    private var onAdd: ((MotionData) -> Void)?
    
    init(
        coreDataManager: CoreDataManagerType = CoreDataManager.shared,
        motionManager: MotionManagerType = MotionManager()
    ) {
        self.coreDataManager = coreDataManager
        self.motionManager = motionManager
    }
    
    func bindOnUpdate(_ closure: @escaping (Coordinate) -> Void) {
        onUpdate = closure
    }
    
    func bindOnAdd(_ closure: @escaping (MotionData) -> Void) {
        onAdd = closure
    }
    
    func action(_ action: Action)  {
        switch action {
        case let .changeSegment(index):
            selectedIndex(index)
        case let .start(index, closure):
            start(selectedIndex: index, closure)
        case let .stop(closure):
            stop(closure)
        }
    }
    
    func throwableAction(_ action: ThrowableAction) throws {
        switch action {
        case .save:
            try save()
        }
    }
    
    private func selectedIndex(_ index: Int) {
        let selectedType = MotionDataType.allCases[index]
        motionData.motionDataType = selectedType
    }
    
    private func start() { }
    
    private func stop() { }
    
    private func saveToCoreData() throws {
        try coreDataManager.save(motionData)
    }
    
    private func saveToDataStorage() throws {
        try dataStorage?.save(motionData)
    }
    
    func motionDataTypes() -> [String] {
        return MotionDataType.allCases.map { $0.rawValue }
    }
}
