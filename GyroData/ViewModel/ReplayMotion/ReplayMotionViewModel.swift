//
//  ReplayMotionViewModel.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import Foundation

final class ReplayMotionViewModel {

    private var fileManager: FileManager
    private var motionData: MotionData!
    private var replayType: ReplayType

    init(index: IndexPath, type: ReplayType) {
        self.fileManager = FileManager.shared
        self.replayType = type
        self.motionData = fetchMotionData(index: index.item)

    }

    func fetchMotionData(index: Int) -> MotionData {
        return fileManager.fetchData(index: index)
    }

    func bindPlayButton() {

    }

    func bindStopButton() {

    }

    func bindPlayTime() {

    }

    func bindCellData() -> (MotionData, ReplayType) {
        return (motionData, replayType)
    }


}
