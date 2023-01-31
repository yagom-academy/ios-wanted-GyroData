//
//  MotionDataTableViewModel.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import Foundation

final class MotionDataTableViewModel {
    
    private var fileManager: FileManager
    private var motionDataListHandler: (() -> ())?
    
    init() {
        self.fileManager = FileManager.shared
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(motionDataBind),
                                               name: Notification.Name("motionDataChanged"),
                                               object: nil)
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
    
    func fetchMotionData(index: Int) -> MotionData {
        return fileManager.fetchData()[index]
    }
    
    func creatMotionData() {
        try? fileManager.createMotionData(type: .gyro, time: 37.4, value: [])
    }
    
    func deleteMotionData(index: Int) {
        fileManager.deleteMotionData(index: index)
    }
}
