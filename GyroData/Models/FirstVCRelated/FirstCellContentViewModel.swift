//
//  FirstCellContentViewModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation

class FirstCellContentViewModel {
    // MARK: Input
    
    // MARK: Output
    var timeSource: (String) -> () = { time in } {
        didSet {
            timeSource(_motion.date.asString(.forDisplay))
        }
    }
    var typeSource: (String) -> () = { type in } {
        didSet {
            typeSource(_motion.type)
        }
    }
    var amountSource: (String) -> () = { amount in } {
        didSet {
            amountSource("\(_motion.time)")
        }
    }
    
    // MARK: Properties
    private var _motion: MotionTask {
        didSet {
            timeSource(_motion.date.asString(.forDisplay))
            typeSource(_motion.type)
            amountSource("\(_motion.time)")
        }
    }
    
    // MARK: Init
    init(_ motion: MotionTask) {
        self._motion = motion
    }
}
