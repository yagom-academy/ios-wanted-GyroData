//
//  Stopwatch.swift
//  GyroData
//
//  Created by seohyeon park on 2022/12/29.
//

import Foundation

class Stopwatch {
    static let share = Stopwatch()
    
    var timer = Timer()
    var isRunning = false
    
    private init() { }
    
    func activateTimer(for time: TimeInterval, _ currentTime: TimeInterval) {
        if (floor(currentTime) == time) || (isRunning == false) {
            timer.invalidate()
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
            print(currentTime, Date())
            self.activateTimer(for: time, currentTime+0.1)
        }
    }
}
