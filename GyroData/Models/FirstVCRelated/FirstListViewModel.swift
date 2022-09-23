//
//  FirstListViewModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation

class FirstListViewModel {
    // MARK: Input
    var didSelectRow: (Int) -> () = { indexPathRow in }
    var didSelectPlayAction: (Int) -> () = { indexPathRow in }
    
    // MARK: Output
    var propagateDidSelectRowEvent: (Int) -> () = { indexPathRow in }
    var propagateDidSelectPlayActionEvent: (Int) -> () = { indexPathRow in }
    var motionDatas: [MotionTask] {
        return _motionDatas
    }
    
    // MARK: Properties
    private var _motionDatas: [MotionTask]
    
    // MARK: Init
    init(_ motionDatas: [MotionTask]) {
        self._motionDatas = motionDatas
        bind()
    }
    
    // MARK: Bind
    private func bind() {
        didSelectRow = { [weak self] indexPathRow in
            guard let self = self else { return }
            self.propagateDidSelectRowEvent(indexPathRow)
        }
        didSelectPlayAction = { [weak self] indexPathRow in
            guard let self = self else { return }
            self.propagateDidSelectPlayActionEvent(indexPathRow)
        }
    }
}
