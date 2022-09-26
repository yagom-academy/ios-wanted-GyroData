//
//  FirstLoadingCellContentViewModel.swift
//  GyroData
//
//  Created by channy on 2022/09/26.
//

import Foundation

class FirstLoadingCellContentViewModel {
    // MARK: Input
    
    // MARK: Output
    var timeSource: (String) -> () = { time in } {
        didSet {
            timeSource(_motion.date.asString())
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
            timeSource(_motion.date.asString())
            typeSource(_motion.type)
            amountSource("\(_motion.time)")
        }
    }
    
    // MARK: Init
    init(_ motion: MotionTask) {
        self._motion = motion
    }
}
