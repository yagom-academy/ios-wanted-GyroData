//
//  MotionReplayViewModel.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/28.
//

import Foundation

final class MotionReplayViewModel {
    let replayType: ReplayType
    let record: MotionRecord
    var didGraphViewStartedDrawing = false
    var playButtonState: PlayButtonState = .play

    init(replayType: ReplayType, record: MotionRecord) {
        self.replayType = replayType
        self.record = record
    }
}

extension MotionReplayViewModel {
    enum PlayButtonState {
        case play
        case stop
    }
}
