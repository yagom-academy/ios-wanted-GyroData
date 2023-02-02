//
//  ReplayMotionViewModel.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import Foundation

final class ReplayMotionViewModel {

    private var fileManager: FileManager

    private var motionDataListHandler: (() -> ())?

    init() {
        self.fileManager = FileManager.shared
    }

    @objc
    private func motionDataBind() {
        motionDataListHandler?()
    }

    func bindMotionDataList(handler: @escaping () -> ()) {
        self.motionDataListHandler = handler
    }

    func fetchMotionDataList() -> [MotionData] {
        return fileManager.fetchData()
    }

    func bindPlayButton() {

    }

    func bindStopButton() {

    }

    func bindPlayTime() {

    }

    func bindCellData() {
        
    }


}
