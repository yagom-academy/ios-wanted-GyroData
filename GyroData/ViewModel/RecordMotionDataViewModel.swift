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
    
    func bind(onUpdate: @escaping (Coordinate) -> Void) {
        self.onUpdate = onUpdate
    }
    
    func bind(onAdd: @escaping (MotionData) -> Void) {
        self.onAdd = onAdd
    }
    
    func action(_ action: Action) {
        switch action {
        case let .changeSegment(index):
            selectedIndex(index)
        case let .start(index, handler):
            start(selectedIndex: index, handler)
        case let .stop(handler):
            stop(handler)
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
        motionData = MotionData(motionDataType: selectedType)
    }
    
    private func start(selectedIndex: Int, _ closure: () -> Void) {
        motionData = MotionData(motionDataType: MotionDataType.allCases.map { $0 } [selectedIndex])
        switch motionData?.motionDataType {
        case .accelerometer:
            motionManager.startAccelerometer { coordinate in
                self.motionData?.coordinates.append(coordinate)
                self.onUpdate?(coordinate)
            }
        case .gyro:
            motionManager.startGyro { coordinate in
                self.motionData?.coordinates.append(coordinate)
                self.onUpdate?(coordinate)
            }
        case .none:
            return
        }
        handler()
    }
    
    private func stop(_ handler: () -> Void) {
        switch motionData?.motionDataType {
        case .accelerometer:
            motionManager.stopAccelerometer()
        case .gyro:
            motionManager.stopGyro()
        case .none:
            return
        }
        handler()
    }
    
    private func save() throws {
        guard let motionData = motionData else { throw MotionDataError.emptyData }
        dataStorage = try DataStorage(directoryName: motionData.motionDataType.rawValue)
        try saveToCoreData()
        try saveToDataStorage()
    }
    
    private func saveToCoreData() throws {
        guard let motionData = motionData else { return }
        try coreDataManager.save(motionData)
    }
    
    private func saveToDataStorage() throws {
        guard let motionData = motionData else { return }
        try dataStorage?.save(motionData)
    }
    
    func motionDataTypes() -> [String] {
        return MotionDataType.allCases.map { $0.rawValue }
    }
}
