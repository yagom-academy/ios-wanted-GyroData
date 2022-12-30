//
//  MotionReplayViewModel.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/28.
//

import Foundation

final class MotionReplayViewModel {
    let replayType: ReplayType
    let recordId: UUID
    var record: MotionRecord?
    var isDrawingGraphView = false
    var playButtonState: PlayButtonState = .play
    private let fetchMotionDataUseCase = FetchMotionDataUseCase()

    init(replayType: ReplayType, id: UUID) {
        self.replayType = replayType
        self.recordId = id
    }

    func fetchMotionData(completion: @escaping () -> Void) {
        fetchMotionDataUseCase.execute(id: recordId) { result in
            switch result {
            case .success(let record):
                self.record = record
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MotionReplayViewModel {
    enum PlayButtonState {
        case play
        case stop
    }
}
