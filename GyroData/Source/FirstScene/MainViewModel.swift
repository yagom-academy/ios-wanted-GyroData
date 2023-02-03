//
//  MainViewModel.swift
//  GyroData
//
//  Created by inho on 2023/02/03.
//

import Foundation

final class MainViewModel {
    private(set) var motionDatas: [MotionData] = [] {
        didSet {
            self.dataHandler?(motionDatas)
        }
    }
    private var dataHandler: (([MotionData]) -> Void)?
    
    func bindData(_ handler: @escaping (([MotionData]) -> Void)) {
        dataHandler = handler
    }
}
