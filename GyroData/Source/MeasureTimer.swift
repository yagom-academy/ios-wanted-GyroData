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
    private var duration: Double
    private var timer: Timer?
    private var isOverdue: Bool {
        return duration < interval
    }

    init(duration: Double, interval: Double) {
        self.duration = duration
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
                    self?.stop()
                    return
                }

                eventHandler()
                self.duration -= self.interval
        })
    }
    
    func stop() {
        timer?.invalidate()
        state = .suspended
    }
}
