//
//  RecordMotionDataViewModel.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

import Foundation

final class RecordMotionDataViewModel {
    enum Action {
        case start(selectedIndex: Int, handler: () -> Void)
        case stop(handler: () -> Void)
        case save
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
    private var onError: ((String) -> Void)?
    
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
    
    func bind(onError: @escaping (String) -> Void) {
        self.onError = onError
    }
    
    func action(_ action: Action) {
        switch action {
        case let .start(index, handler):
            start(selectedIndex: index, handler)
        case let .stop(handler):
            stop(handler)
        case .save:
            DispatchQueue.global().async {
                self.save()
            }
        }
    }
    
    private func start(selectedIndex: Int, _ handler: () -> Void) {
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
    
    private func save() {
        guard var motionData = motionData else {
            self.onError?(MotionDataError.emptyData.localizedDescription)
            return
        }
        motionData.length = round(Double(motionData.coordinates.count)) / 10
        do {
            dataStorage = try DataStorage(directoryName: motionData.motionDataType.rawValue)
            try saveToCoreData(motionData)
            try saveToDataStorage(motionData)
            self.onAdd?(motionData)
            self.motionData = nil
        } catch {
            onError?(error.localizedDescription)
        }
    }
    
    private func saveToCoreData(_ motionData: MotionData) throws {
        try coreDataManager.save(motionData)
    }
    
    private func saveToDataStorage(_ motionData: MotionData) throws {
        try dataStorage?.save(motionData)
    }
    
    func motionDataTypes() -> [String] {
        return MotionDataType.allCases.map { $0.rawValue }
    }
}
