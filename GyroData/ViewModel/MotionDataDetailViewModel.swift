//
//  MotionDataDetailViewModel.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

import Foundation

final class MotionDataDetailViewModel {
    enum Constant {
        enum Namespace {
            static let timeInterval = 1.0 / 10.0
        }
    }
    
    enum Action {
        case onAppear
        case buttonTapped(handler: (String) -> Void)
        case didAppear(handler: ([Coordinate]) -> Void)
    }
    
    enum ButtonState {
        case isPlaying
        case isStopped
        
        mutating func toggle() {
            switch self {
            case .isPlaying:
                self = .isStopped
            case .isStopped:
                self = .isPlaying
            }
        }
        
        var buttonImage: String {
            switch self {
            case .isPlaying:
                return "stop.fill"
            case .isStopped:
                return "play.fill"
            }
        }
    }

    
    private let viewType: DetailViewType
    private let motionData: MotionData
    private var dataStorage: DataStorageType?
    private var setNavigationTitle: ((String) -> Void)?
    private var setViewTypeText: ((String) -> Void)?
    private var showPlayViewComponents: (() -> Void)?
    private var isPlaying: ButtonState = ButtonState.isStopped
    private var onUpdate: ((Coordinate, String) -> Void)?
    private var onSetGraphView: (([Coordinate]) -> Void)?
    private var timer: Timer?
    private var startTime: Date = Date()
    
    init(
        viewType: DetailViewType,
        motionData: MotionData,
        onUpdate: ((Coordinate, String) -> Void)? = nil
    ) throws {
        self.viewType = viewType
        self.motionData = motionData
        self.onUpdate = onUpdate
        try setDataStorage()
    }
    
    func bind(
        setNavigationTitle: @escaping (String) -> Void,
        setViewTypeText: @escaping (String) -> Void,
        showPlayViewComponents: @escaping () -> Void
    ) {
        self.setNavigationTitle = setNavigationTitle
        self.setViewTypeText = setViewTypeText
        self.showPlayViewComponents = showPlayViewComponents
    }
    
    func bind(onUpdate: @escaping ((Coordinate, String) -> Void)) {
        self.onUpdate = onUpdate
    }
    
    func bind(onSetGraphView: @escaping ([Coordinate]) -> Void) {
        self.onSetGraphView = onSetGraphView
    }
    
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            setNavigationTitle?(motionData.createdAt.dateTimeString())
            setDetailViewType()
        case let .buttonTapped(handler):
            isPlaying.toggle()
            handler(isPlaying.buttonImage)
            switch isPlaying {
            case .isPlaying:
                play()
            case .isStopped:
                pause()
            }
        case let .didAppear(handler):
            if viewType == .view {
                guard let coordinates = fetchCoordinateData() else { return }
                handler(coordinates)
            }
        }
    }
    
    private func setDetailViewType() {
        switch viewType {
        case .view:
            setViewTypeText?(viewType.rawValue)
        case .play:
            setViewTypeText?(viewType.rawValue)
            showPlayViewComponents?()
        }
    }
    
    private func setDataStorage() throws {
        do {
            dataStorage = try DataStorage(directoryName: motionData.motionDataType.rawValue)
        } catch {
            throw DataStorageError.cannotFindDirectory
        }
    }
    
    private func play() {
        guard let coordinates = fetchCoordinateData() else { return }
        onSetGraphView?(coordinates)
        var reversed = Array(coordinates.reversed())
        startTime = Date()
        timer = Timer.scheduledTimer(
            withTimeInterval: Constant.Namespace.timeInterval,
            repeats: true,
            block: { _ in
                guard reversed.isEmpty == false else {
                    self.pause()
                    return
                }
                let elapsedTime = Date().timeIntervalSince(self.startTime)
                let truncatedTime = round(elapsedTime * 10) / 10
                self.onUpdate?(reversed.removeLast(), truncatedTime.description)
        })
    }
    
    // TODO: - stop으로 수정
    private func pause() {
        timer?.invalidate()
    }
    
    private func fetchCoordinateData() -> [Coordinate]? {
        let data = dataStorage?.read(motionData.id.description)
        return data?.coordinates
    }
}
