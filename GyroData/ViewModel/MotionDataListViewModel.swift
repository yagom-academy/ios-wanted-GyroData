//
//  MotionDataListViewModel.swift
//  GyroData
//
//  Created by Jiyoung Lee on 2023/01/31.
//

import Foundation

final class MotionDataListViewModel {
    private var motionData: [MotionData] = [] {
        didSet {
            onUpdate?()
        }
    }
    private let coreDataManager: CoreDataManagerType
    private var onUpdate: (() -> Void)?
    private var onError: ((String) -> Void)?
    private let pagingLimit = 10

    init(coreDataManager: CoreDataManagerType = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }

    private func createNewRecordMotionDataViewModel(_ handler: @escaping (RecordMotionDataViewModel) -> Void) {
        guard let dataStorage = try? DataStorage(directoryName: "") else { return }
        let newMotionData = MotionData(motionDataType: .accelerometer)
        let motionManager = MotionManager()
        let newRecordMotionDataViewModel = RecordMotionDataViewModel(
            motionData: newMotionData,
            dataStorage: dataStorage,
            motionManager: motionManager
        )
        newRecordMotionDataViewModel.bindOnAdd { [weak self] motionData in
            self?.add(motionData)
        }
        handler(newRecordMotionDataViewModel)
    }

    private func createMotionDataDetailViewModel(
        _ data: MotionData,
        _ handler: @escaping (MotionDataDetailViewModel) -> Void
    ) {
        let motionDataDetailViewModel = MotionDataDetailViewModel(motionData: data)
        handler(motionDataDetailViewModel)
    }

    private func add(_ data: MotionData) {
        motionData.insert(data, at: 0)
    }

    private func delete(at indexPath: IndexPath) {
        motionData.remove(at: indexPath.row)
    }

    func numberOfData() -> Int {
        return motionData.count
    }

    func motionData(at indexPath: IndexPath) -> MotionData? {
        guard indexPath.row < motionData.count else { return nil }
        return motionData[indexPath.row]
    }

    func bind(onUpdate: @escaping () -> Void) {
        self.onUpdate = onUpdate
    }

    func bind(onError: @escaping (String) -> Void) {
        self.onError = onError
    }

    func fetchMotionData() {
        let offset = numberOfData()
        let limit = pagingLimit
        do {
            var motionData = [MotionData]()
            motionData = try coreDataManager.read(offset: offset, limit: limit).compactMap { entity in
                guard let motionDataType = MotionDataType(rawValue: entity.motionDataType) else { return nil }
                return MotionData(
                    id: entity.id,
                    createdAt: entity.createdAt,
                    length: entity.length,
                    motionDataType: motionDataType
                )
            }
            if motionData.isEmpty == false {
                self.motionData.append(contentsOf: motionData)
            }
        } catch {
            onError?(error.localizedDescription)
        }
    }
}

extension MotionDataListViewModel {
    enum Action {
        case tappedRecordButton(handler: (RecordMotionDataViewModel) -> Void)
        case view(at: IndexPath, handler: (MotionDataDetailViewModel) -> Void)
        case play(at: IndexPath, handler: (MotionDataDetailViewModel) -> Void)
        case delete(at: IndexPath)
        case scrollToBottom
    }

    func action(_ action: Action) {
        switch action {
        case let .tappedRecordButton(handler):
            createNewRecordMotionDataViewModel(handler)
        case let .view(indexPath, handler):
            guard let data = motionData(at: indexPath) else { break }
            createMotionDataDetailViewModel(data, handler)
            break
        case let .play(indexPath, handler):
            guard let data = motionData(at: indexPath) else { break }
            createMotionDataDetailViewModel(data, handler)
            break
        case let .delete(indexPath):
            delete(at: indexPath)
            break
        case .scrollToBottom:
            fetchMotionData()
            break
        }
    }
}

