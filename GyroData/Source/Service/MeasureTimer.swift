//
//  MeasureTimer.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/02.
//

import Foundation

final class MeasureTimer {
    private enum State {
        case active
        case suspended
    }

    private var state: State = .suspended
    private var interval: Double
    private var duration: Int = 0
    private var deadline: Double
    private var timer: Timer?
    private var isOverdue: Bool {
        return duration == Int(deadline * 10)
    }

    init(deadline: Double, interval: Double) {
        self.deadline = deadline
        self.interval = interval
    }
    
    func activate(eventHandler: @escaping (() -> Void)) {
        guard state != .active else { return }
        state = .active
        
        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: true,
            block: { [weak self] timer in
                guard let self = self,
                      self.isOverdue == false
                else {
                    self?.resetTimer()
                    // TODO: 타임오바
                    return
                }

                eventHandler()
                self.duration += Int(self.interval * 10)
        })
    }
    
    func stop() -> Double {
        resetTimer()
        
        return Double(duration) / Double(10)
    }
    
    private func resetTimer() {
        timer?.invalidate()
        state = .suspended
    }
}
