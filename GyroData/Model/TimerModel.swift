//
//  TimerModel.swift
//  GyroData
//
//  Created by 리지 on 2023/06/15.
//

import Foundation
import Combine

final class TimerModel {
    @Published var tenthOfaSeconds: Double = 0
    var isStop = PassthroughSubject<Bool, Never>()
    
    func startTimer() {
        tenthOfaSeconds += 0.1
    }
    
    func stopTimer(_ bool: Bool) {
        isStop.send(bool)
    }
    
    func restartTimer() {
        tenthOfaSeconds = 0
    }
}
