//
//  MotionGraphViewModel.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

protocol MotionGraphViewModelDelegate: AnyObject {
    func motionGraphViewModel(willDisplayDate date: String, type: String, data: Motion.MeasurementData)
}

final class MotionGraphViewModel {
    enum Constant {
        static let dateFormat = "yyyy/MM/dd HH:mm:ss"
    }
    enum Action {
        case viewWillAppear
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
        case .viewWillAppear:
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
        
        delegate?.motionGraphViewModel(
            willDisplayDate: motion.date.formatted(by: Constant.dateFormat),
            type: motion.type.text,
            data: motion.data)
    }
}
