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
    private var eventHandler: (() -> Void)?
    private var timer: Timer?
    private var isOverdue: Bool {
        return duration < interval
    }

    init(duration: Double, interval: Double, eventHandler: (() -> Void)? = nil) {
        self.duration = duration
        self.interval = interval
        self.eventHandler = eventHandler
    }
    
    func activate() {
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

                self.eventHandler?()
                self.duration -= self.interval
        })
    }
    
    func stop() {
        timer?.invalidate()
    }
}
