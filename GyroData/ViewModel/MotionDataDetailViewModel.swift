//
//  MotionDataDetailViewModel.swift
//  GyroData
//
//  Created by Jiyoung Lee on 2023/01/31.
//

import Foundation

final class MotionDataDetailViewModel {
    enum Action {
        case play
        case pause
    }
    
    private let motionData: MotionData
    private var onUpdate: ((Coordinate) -> Void)?
    
    init(motionData: MotionData, onUpdate: ((Coordinate) -> Void)? = nil) {
        self.motionData = motionData
        self.onUpdate = onUpdate
    }
    
    func bindOnUpdate(_ closure: @escaping ((Coordinate) -> Void)) {
        onUpdate = closure
    }
    
    func action(_ action: Action) {
        switch action {
        case .play:
            play()
        case .pause:
            pause()
        }
    }
    
    private func play() { }
    
    private func pause() { }
}
