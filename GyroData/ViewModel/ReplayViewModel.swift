//
//  ReplayViewModel.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import Foundation

protocol ReplayInput {
    func load()
}

protocol ReplayOutput {
    var motionMode: Observable<MotionMode> { get }
    var error: Observable<String> { get }
    var graphData: Observable<GyroData> { get }
}

struct ReplayViewModel: ReplayInput, ReplayOutput {
    private let fileDataManager = FileDataManager.shared
    var motionMode: Observable<MotionMode> = Observable(value: nil)
    var graphData: Observable<GyroData> = Observable(value: nil)
    var error: Observable<String> = Observable(value: nil)
    var motionID : UUID?

    init(information: GyroInformationModel) {
        motionID = information.id
    }

    func load() {
        guard let motionID = motionID else { return }
        motionMode.value = fileDataManager.fetch(id: motionID, completion: { result in
            switch result {
            case .success:
                return
            case .failure(let failure):
                self.error.value = failure.message
            }
        })
    }
}
