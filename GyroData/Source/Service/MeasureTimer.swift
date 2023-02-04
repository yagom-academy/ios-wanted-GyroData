//
//  MeasureTimer.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/02.
//

import Foundation

protocol MeasureTimerDelegate: AnyObject {
    func timeOver(duration: Double)
}

final class MeasureTimer {
    private enum State {
        case active
        case suspended
    }
    
    weak var delegate: MeasureTimerDelegate?
    private var state: State = .suspended
    private var interval: Double
    private var duration: Int = .zero
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
        duration = .zero
        
        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: true,
            block: { [weak self] timer in
                guard let self = self,
                      self.isOverdue == false
                else {
                    self?.timeOver()
                    return
                }
                
                eventHandler()
                self.duration += Int(self.interval * 10)
            })
    }
    
    @discardableResult
    func stop() -> Double {
        resetTimer()
        
        return duration.convertDoubleDuration
    }
    
    private func resetTimer() {
        timer?.invalidate()
        state = .suspended
    }
    
    private func timeOver() {
        resetTimer()
        delegate?.timeOver(duration: duration.convertDoubleDuration)
    }
}

extension Int {
    var convertDoubleDuration: Double {
        return Double(self) / Double(10)
    }
}
