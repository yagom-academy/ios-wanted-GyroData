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
    var didPlayStarted = false

    init(replayType: ReplayType, record: MotionRecord) {
        self.replayType = replayType
        self.record = record
    }
}
