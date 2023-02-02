//
//  MotionGraphViewModel.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

protocol MotionViewDelegate: AnyObject {
    func motionViewModel(willDisplayMotion motion: Motion)
}

struct MotionGraphViewModel {
    enum Action {
        case viewWillAppear
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewWillAppear:
            break
        }
    }
}

