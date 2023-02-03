//
//  MotionViewModel.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

protocol MotionViewDelegate: AnyObject {
    func motionViewModel(willDisplayMotion motion: Motion)
}

final class MotionViewModel {
    enum Action {
        case viewWillAppear
    }
    
    private let motionID: String
    private let readService: FileManagerMotionReadService
    private weak var delegate: MotionViewDelegate?
    
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
    
    func configureDelegate(_ delegate: MotionViewDelegate) {
        self.delegate = delegate
    }
}

private extension MotionViewModel {
    func fetchMotion(with id: String) {
        guard let motion = readService.read(with: motionID) else { return }
        
        delegate?.motionViewModel(willDisplayMotion: motion)
    }
}
