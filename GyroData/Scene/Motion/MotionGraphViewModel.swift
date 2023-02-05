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
}

final class MotionGraphViewModel {
    enum Constant {
        static let dateFormat = "yyyy/MM/dd HH:mm:ss"
    }
    enum Action {
        case viewWillAppear
        case viewDidAppear
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
        }
    }
    
    func configureDelegate(_ delegate: MotionGraphViewModelDelegate) {
        self.delegate = delegate
    }
}

private extension MotionGraphViewModel {
    func fetchMotion(with id: String) {
        guard let motion = readService.read(with: motionID) else { return }
        var motionData: [MotionData] = []
        for index in 0..<motion.data.x.count {
            motionData.append(MotionData(x: motion.data.x[index], y: motion.data.y[index], z: motion.data.z[index]))
        }
        
        delegate?.motionGraphViewModel(
            actionConfigurationAboutViewDidAppear: motion.date.formatted(by: Constant.dateFormat),
            title: "\(motion.type.text) \(style.title)",
            data: motionData)
    }
}
