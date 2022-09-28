//
//  ThirdInfoViewModel.swift
//  GyroData
//
//  Created by 한경수 on 2022/09/21.
//

import Foundation

class ThirdInfoViewModel {
    // MARK: Input
    var didReceiveViewType: (ViewType) -> () = { type in }
    var didReceiveMotion: (MotionTask) -> () = { motion in }
    
    // MARK: Output
    var viewTypeSource: (ViewType) -> () = { type in } {
        didSet {
            viewTypeSource(_viewType)
        }
    }
    
    var dateSource: (String) -> () = { date in } {
        didSet {
            dateSource(_motion.date.asString(.forDisplay))
        }
    }
    
    // MARK: Properties
    private var _viewType: ViewType {
        didSet {
            viewTypeSource(_viewType)
        }
    }
    private var _motion: MotionTask {
        didSet {
            dateSource(_motion.date.asString(.forDisplay))
        }
    }
    
    // MARK: Init
    init(viewType: ViewType, motion: MotionTask) {
        self._viewType = viewType
        self._motion = motion
        bind()
    }
    
    // MARK: Bind
    func bind() {
        didReceiveViewType = { [weak self] viewType in
            self?._viewType = viewType
        }
        
        didReceiveMotion = { [weak self] motion in
            self?._motion = motion
        }
    }
}
