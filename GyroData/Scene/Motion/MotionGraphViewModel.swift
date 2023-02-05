//
//  MotionGraphViewModel.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

protocol MotionGraphViewModelDelegate: AnyObject {
    func motionGraphViewModel(
        actionConfigurationAboutViewDidAppear date: String,
        title: String,
        data: [MotionDataType]
    )
    func motionGraphViewModel(actionConfigurationAboutViewWillAppear isPlayButtonHidden: Bool)
    func motionGraphViewModel(data: MotionDataType, at time: String)
}

final class MotionGraphViewModel {
    enum Constant {
        static let dateFormat = "yyyy/MM/dd HH:mm:ss"
    }
    enum Action {
        case viewWillAppear
        case viewDidAppear
        case playButtonTap
        case stopButtonTap
    }
    enum Style {
        case play, view
        
        var title: String {
            switch self {
            case .play:
                return "Play"
            case .view:
                return "View"
            }
        }
    }
    
    private let style: Style
    private let motionID: String
    private var motion: Motion?
    private var playTimer: Timer?
    private let readService: FileManagerMotionReadService
    private weak var delegate: MotionGraphViewModelDelegate?
    
    init(style: Style, motionID: String, readService: FileManagerMotionReadService) {
        self.style = style
        self.motionID = motionID
        self.readService = readService
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewWillAppear:
            delegate?.motionGraphViewModel(
                actionConfigurationAboutViewWillAppear: style == .view ? true : false
            )
        case .viewDidAppear:
            fetchMotion(with: motionID)
        case .playButtonTap:
            play()
        case .stopButtonTap:
            stop()
        }
    }
    
    func configureDelegate(_ delegate: MotionGraphViewModelDelegate) {
        self.delegate = delegate
    }
}

private extension MotionGraphViewModel {
    func play() {
        var index = 0
        playTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let motion = self?.motion, index < Int(motion.time * 10) else {
                self?.playTimer?.invalidate()
                return
            }
            self?.delegate?.motionGraphViewModel(
                data: MotionData(
                    x: motion.data.x[index],
                    y: motion.data.y[index],
                    z: motion.data.z[index]
                ),
                at: String(format: "%.1f", Double(index + 1) / 10.0)
            )
            index += 1
        }
    }
    
    func stop() {
        playTimer?.invalidate()
    }
    
    func fetchMotion(with id: String) {
        guard let currentMotion = readService.read(with: motionID) else { return }
        motion = currentMotion
        var motionData: [MotionData] = []
        for index in 0..<currentMotion.data.x.count {
            motionData.append(
                MotionData(
                    x: currentMotion.data.x[index],
                    y: currentMotion.data.y[index],
                    z: currentMotion.data.z[index]
                )
            )
        }
        
        delegate?.motionGraphViewModel(
            actionConfigurationAboutViewDidAppear: currentMotion.date.formatted(by: Constant.dateFormat),
            title: "\(currentMotion.type.text) \(style.title)",
            data: style == .view ? motionData : []
        )
    }
}
