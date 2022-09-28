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
    var didSelectDeleteAction: (Int) -> () = { IndexPathRow in }
    var didReceiveMotionTasks: ([MotionTask]) -> () = { motionTasks in }
    var didReceiveStartPaging: () -> () = { }
    var didReceiveEndPaging: () -> () = { }
    
    // MARK: Output
    var propagateDidSelectRowEvent: (MotionTask) -> () = { motion in }
    var propagateDidSelectPlayActionEvent: (MotionTask) -> () = { motion in }
    var propagateDidSelectDeleteActionEvent: (MotionTask) -> () = { motion in }
    var motionTasks: [MotionTask] {
        return _motionTasks
    }
    var didReceiveViewModel: ( ((Void)) -> () )?
    var propagateFetchMotionTasks: () -> () = { }
    var isPaging: Bool {
        return _isPaging
    }
    var propagateStartPaging: () -> () = { }
    
    // MARK: Properties
    private var _motionTasks: [MotionTask]
    private var _totalMotionTasks: [MotionTask]
    private var _currentTaskIndex: Int
    private var _isPaging: Bool
    
    // MARK: Init
    init(_ motionTasks: [MotionTask]) {
        self._totalMotionTasks = motionTasks
        self._motionTasks = motionTasks
        self._currentTaskIndex = 9
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
        didSelectDeleteAction = { [weak self] indexPathRow in
            guard let self = self else { return }
            let motion = self._motionTasks[indexPathRow]
            self.propagateDidSelectDeleteActionEvent(motion)
        }
        didReceiveMotionTasks = { [weak self] motionTasks in
            guard let self = self else { return }
            self._currentTaskIndex = 0
            self._totalMotionTasks = motionTasks
            if !self.isEmptyTotalMotionTasks() {
                self._currentTaskIndex = min(self._totalMotionTasks.count-1, self._currentTaskIndex + 10)
                self._motionTasks = Array<MotionTask>(self._totalMotionTasks[0...self._currentTaskIndex])
            } else {
                self._motionTasks = []
            }
            self.propagateFetchMotionTasks()
        }
        didReceiveStartPaging = { [weak self] in
            guard let self = self else { return }
            self._isPaging = true
            self.propagateStartPaging()
        }
        didReceiveEndPaging = {
            self._isPaging = false
            if !self.isEmptyTotalMotionTasks() {
                self._currentTaskIndex = min(self._totalMotionTasks.count-1, self._currentTaskIndex + 10)
                self._motionTasks = Array<MotionTask>(self._totalMotionTasks[0...self._currentTaskIndex])
            } else {
                self._motionTasks = []
            }
            self.propagateFetchMotionTasks()
        }
    }
    
    func isScrollAvailable() -> Bool {
        return !(self._totalMotionTasks.count-1 == self._currentTaskIndex)
    }
    
    func isEmptyTotalMotionTasks() -> Bool {
        return self._totalMotionTasks.isEmpty
    }
}
