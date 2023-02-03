//
//  MeasureViewModel.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/03.
//

import Foundation

final class MeasureViewModel {
    enum Action {
        case motionTypeChange(with: String?)
        case measure
        case stop
        case save
    }
    
    func action(_ action: Action) {
        switch action {
        case .motionTypeChange(let type):
            // TODO: 모션 타입 변경
            break
        case .measure:
            // TODO: 측정 시작
            break
        case .stop:
            // TODO: 정지
            break
        case .save:
            // TODO: 저장
            break
        }
    }
}
