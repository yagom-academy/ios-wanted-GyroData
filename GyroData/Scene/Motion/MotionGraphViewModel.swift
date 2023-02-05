//
//  MotionGraphViewModel.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

protocol MotionGraphViewModelDelegate: AnyObject {
    func motionGraphViewModel(willDisplayDate date: String, type: String, data: [MotionDataType])
}

final class MotionGraphViewModel {
    enum Constant {
        static let dateFormat = "yyyy/MM/dd HH:mm:ss"
    }
    enum Action {
        case viewDidAppear
    }
    
    private let motionID: String
    private let readService: FileManagerMotionReadService
    private weak var delegate: MotionGraphViewModelDelegate?
    
    init(motionID: String, readService: FileManagerMotionReadService) {
        self.motionID = motionID
        self.readService = readService
    }
    
    func action(_ action: Action) {
        switch action {
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
            willDisplayDate: motion.date.formatted(by: Constant.dateFormat),
            type: motion.type.text,
            data: motionData)
    }
}
