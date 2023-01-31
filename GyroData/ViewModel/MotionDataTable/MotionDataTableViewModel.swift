//
//  MotionDataTableViewModel.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

final class MotionDataTableViewModel {
    
    private var fileManager: FileManager {
        didSet {
            motionDataListHandler?()
        }
    }
    
    private var motionDataListHandler: (() -> ())?
    
    init() {
        self.fileManager = FileManager.shared
    }
    
    func bindMotionDataList(handler: @escaping () -> ()) {
        self.motionDataListHandler = handler
    }
    
    func fetchMotionDataList() -> [(date: String, type: String, time: String)] {
        let list = fileManager.fetchData().map {
            ($0.date.description, $0.type.rawValue, $0.time.description)
        }
        return list
    }
    
    func fetchMotionData(index: Int) -> MotionData {
        return fileManager.fetchData()[index]
    }
    
    func deleteMotionData(index: Int) {
        fileManager.deleteMotionData(index: index)
    }
}
