//
//  DetailViewModel.swift
//  GyroData
//
//  Created by 이원빈 on 2022/12/29.
//

import Foundation

protocol DetailViewModelInput {
    
}

protocol DetailViewModelOutput {
    
}

final class DetailViewModel: DetailViewModelInput, DetailViewModelOutput {
    private var timer: Timer?
    private var timerNum: Double = 0.0
    weak var delegate: GraphDrawable?
    let model: MeasuredData
    let currenType: DetailType
    
    init(data: MeasuredData, type: DetailType) {
        currenType = type
        model = data
    }
    
    func resetGraphView() {
        delegate?.stopDraw()
    }
    
    func startTimer(_ completion: @escaping (String) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            
            guard let self = self else {
                return
            }
            self.delegate?.startDraw()
            self.timerNum += 0.1
            completion(self.timerNum.timeDecimal().description)
            
            if self.timerNum.timeDecimal() == self.model.measuredTime {
                self.timer?.invalidate()
                self.timerNum = 0
            }
        })
    }
    
    func stopTimer(_ completion: () -> Void) {
        completion()
        timer?.invalidate()
        self.timerNum = 0
    }
}
