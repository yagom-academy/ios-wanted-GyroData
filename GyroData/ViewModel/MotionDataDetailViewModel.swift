//
//  MotionDataDetailViewModel.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

import Foundation

final class MotionDataDetailViewModel {
    enum Action {
        case onAppear
        case play
        case pause
    }
    
    private let viewType: DetailViewType
    private let motionData: MotionData
    private var dataStorage: DataStorageType?
    private var navigationTitle: ((String) -> Void)?
    private var viewTypeText: ((String) -> Void)?
    private var showButton: (() -> Void)?
    private var onUpdate: ((Coordinate) -> Void)?
    
    init(
        viewType: DetailViewType,
        motionData: MotionData,
        onUpdate: ((Coordinate) -> Void)? = nil
    ) throws {
        self.viewType = viewType
        self.motionData = motionData
        self.onUpdate = onUpdate
        try setDataStorage()
    }
    
    func bind(
        navigationTitle: @escaping (String) -> Void,
        viewTypeText: @escaping (String) -> Void,
        showButton: @escaping () -> Void
    ) {
        self.navigationTitle = navigationTitle
        self.viewTypeText = viewTypeText
        self.showButton = showButton
    }
    
    func bind(onUpdate: @escaping ((Coordinate) -> Void)) {
        self.onUpdate = onUpdate
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            setNavigationTitle()
            setDetailViewType()
        case .play:
            play()
        case .pause:
            pause()
        }
    }
    
    private func setNavigationTitle() {
        navigationTitle?(motionData.createdAt.dateTimeString())
    }
    
    private func setDetailViewType() {
        switch viewType {
        case .view:
            viewTypeText?(viewType.rawValue)
        case .play:
            viewTypeText?(viewType.rawValue)
            showButton?()
        }
    }
    
    private func setDataStorage() throws {
        do {
            dataStorage = try DataStorage(directoryName: motionData.motionDataType.rawValue)
        } catch {
            throw DataStorageError.cannotFindDirectory
        }
    }
    
    private func play() { }
    
    private func pause() { }
    
    private func fetchCoordinateData() -> [Coordinate]? {
        let data = dataStorage?.read(motionData.id.description)
        return data?.coordinates
    }
}
