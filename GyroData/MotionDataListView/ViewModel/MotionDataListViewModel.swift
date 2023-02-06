//
//  MotionDataListViewModel.swift
//  GyroData
//
//  Created by junho on 2023/01/31.
//

import Foundation

final class MotionDataListViewModel {
    enum Constant {
        enum Namespace {
            static let pagingLimit: Int = 10
        }
    }
    
    enum Action {
        case record(handler: (RecordMotionDataViewModel) -> Void)
        case view(at: IndexPath, handler: (MotionDataDetailViewModel) -> Void)
        case play(at: IndexPath, handler: (MotionDataDetailViewModel) -> Void)
        case remove(at: IndexPath)
        case fetchData
    }

    private var motionData: [MotionData] = [] {
        didSet {
            onInsert?()
        }
    }
    private let coreDataManager: CoreDataManagerType
    private var onInsert: (() -> Void)?
    private var onError: ((String) -> Void)?
    private let pagingLimit = Constant.Namespace.pagingLimit

    init(coreDataManager: CoreDataManagerType = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }

    private func createRecordMotionDataViewModel(_ handler: @escaping (RecordMotionDataViewModel) -> Void) {
        let recordMotionDataViewModel = RecordMotionDataViewModel(motionManager: MotionManager())
        recordMotionDataViewModel.bind(onAdd: { [weak self] motionData in
            self?.insert(motionData)
        })
        handler(recordMotionDataViewModel)
    }

    private func createMotionDataDetailViewModelToView(
        _ data: MotionData,
        _ handler: @escaping (MotionDataDetailViewModel) -> Void
    ) {
        guard let motionDataDetailViewModel = try? MotionDataDetailViewModel(
            viewType: .view,
            motionData: data
        ) else { return }
        handler(motionDataDetailViewModel)
    }

    private func createMotionDataDetailViewModelToPlay(
        _ data: MotionData,
        _ handler: @escaping (MotionDataDetailViewModel) -> Void
    ) {
        guard let motionDataDetailViewModel = try? MotionDataDetailViewModel(
            viewType: .play,
            motionData: data
        ) else { return }
        handler(motionDataDetailViewModel)
    }

    private func insert(_ data: MotionData) {
        motionData.insert(data, at: .zero)
    }

    private func remove(at indexPath: IndexPath) {
        motionData.remove(at: indexPath.row)
    }

    private func fetchMotionData() {
        let offset: Int = numberOfData()
        let limit: Int = pagingLimit
        do {
            var motionData = [MotionData]()
            motionData = try coreDataManager
                .read(offset: offset, limit: limit)
                .compactMap { entity in
                guard let motionDataType = MotionDataType(rawValue: entity.motionDataType) else { return nil }
                return MotionData(
                    id: entity.id,
                    createdAt: entity.createdAt,
                    length: entity.length,
                    motionDataType: motionDataType
                )
            }
            if motionData.isEmpty == false { self.motionData.append(contentsOf: motionData) }
        } catch {
            onError?(error.localizedDescription)
        }
    }
    
    private func motionData(at indexPath: IndexPath) -> MotionData? {
        guard indexPath.row < motionData.count else { return nil }
        return motionData[indexPath.row]
    }

    func bind(onInsert: @escaping () -> Void) {
        self.onInsert = onInsert
    }

    func bind(onError: @escaping (String) -> Void) {
        self.onError = onError
    }

    func action(_ action: Action) {
        switch action {
        case let .record(handler):
            createRecordMotionDataViewModel(handler)
        case let .view(indexPath, handler):
            guard let data = motionData(at: indexPath) else { break }
            createMotionDataDetailViewModelToView(data, handler)
            break
        case let .play(indexPath, handler):
            guard let data = motionData(at: indexPath) else { break }
            createMotionDataDetailViewModelToPlay(data, handler)
            break
        case let .remove(indexPath):
            remove(at: indexPath)
            break
        case .fetchData:
            fetchMotionData()
            break
        }
    }

    func numberOfData() -> Int {
        return motionData.count
    }

    func configureCell(
        for indexPath: IndexPath,
        handler: (_ createdAt: String, _ type: String, _ length: String) -> Void
    ) {
        guard let motionData = motionData(at: indexPath) else { return }
        handler(
            motionData.createdAt.dateTimeString(),
            motionData.motionDataType.rawValue,
            motionData.length.description
        )
    }
}
