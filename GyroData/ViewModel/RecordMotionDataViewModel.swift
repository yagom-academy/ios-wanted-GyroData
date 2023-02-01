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
    
    func action(_ action: Action)  {
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
    
    // start에서 하는 일
    // 1. 배열에 값 append
    // 2. 뷰컨에서 graphView에 그리도록 하는 클로저 실행
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
        closure()
    }
    
    private func stop(_ closure: () -> Void) {
        switch motionData?.motionDataType {
        case .accelerometer:
            motionManager.stopAccelerometer()
        case .gyro:
            motionManager.stopGyro()
        case .none:
            return
        }
        closure()
    }
    
    private func save() throws {
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
