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
    var didReceiveMotionTasks: ([MotionTask]) -> () = { motionTasks in }
    var didReceiveStartPaging: () -> () = { }
    var didReceiveEndPaging: () -> () = { }
    
    // MARK: Output
    var propagateDidSelectRowEvent: (MotionTask) -> () = { motion in }
    var propagateDidSelectPlayActionEvent: (MotionTask) -> () = { motion in }
    var motionTasks: [MotionTask] {
        return _motionTasks
    }
    var didReceiveViewModel: ( ((Void)) -> () )?
    var propagateFetchMotionTasks: ( ((Void)) -> () )?
    var isPaging: Bool {
        return _isPaging
    }
    var propagateStartPaging: ( ((Void)) -> () )?
    
    // MARK: Properties
    private var _motionTasks: [MotionTask]
    private var _isPaging: Bool
    
    // MARK: Init
    init(_ motionDatas: [MotionTask]) {
        self._motionTasks = motionDatas
        self._isPaging = false
        bind()
    }
    
    // MARK: Bind
    private func bind() {
        didSelectRow = { [weak self] indexPathRow in
            guard let self = self else { return }
            let motion = self._motionTasks[indexPathRow]
            self.propagateDidSelectRowEvent(motion)
        }
        didSelectPlayAction = { [weak self] indexPathRow in
            guard let self = self else { return }
            let motion = self._motionTasks[indexPathRow]
            self.propagateDidSelectPlayActionEvent(motion)
        }
        didReceiveMotionTasks = { [weak self] motionTasks in
            guard let self = self else { return }
            self._motionTasks = motionTasks
        }
        didReceiveStartPaging = {
            self._isPaging = true
            self.propagateStartPaging?(())
        }
        didReceiveEndPaging = {
            self._isPaging = false
            // TO-DO : CoreData 와 연결
            self._motionTasks += self._motionTasks[0...9]
        }
    }
}
