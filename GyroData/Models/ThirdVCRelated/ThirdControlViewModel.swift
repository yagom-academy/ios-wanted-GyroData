//
//  ThirdControlViewModel.swift
//  GyroData
//
//  Created by CodeCamper on 2022/09/22.
//

import Foundation

class ThirdControlViewModel {
    // MARK: Input
    var didTapControlButton: () -> () = { }
    var didReceiveMotion: (MotionTask) -> () = { motion in }
    
    // MARK: Output
    var isPlayingSource: (Bool) -> () = { isPlaying in } {
        didSet {
            isPlayingSource(_isPlaying)
        }
    }
    
    var currentTimeSource: (Float) -> () = { currentTime in } {
        didSet {
            currentTimeSource(_currentTime)
        }
    }
    
    var propagateCurrentTime: (Float) -> () = { currentTime in } {
        didSet {
            currentTimeSource(_currentTime)
        }
    }
    
    var propagateIsPlaying: (Bool) -> () = { isPlaying in } {
        didSet {
            propagateIsPlaying(_isPlaying)
        }
    }
    
    // MARK: Properties
    private var _isPlaying: Bool = false {
        didSet {
            isPlayingSource(_isPlaying)
            propagateIsPlaying(_isPlaying)
        }
    }
    private var _currentTime: Float = 0 {
        didSet {
            currentTimeSource(_currentTime)
            propagateCurrentTime(_currentTime)
        }
    }
    private var _motion: MotionTask
    private var timer: Timer?
    
    // MARK: Init
    init(motion: MotionTask) {
        self._motion = motion
        bind()
    }
    
    // MARK: Bind
    func bind() {
        didTapControlButton = { [weak self] in
            guard let self else { return }
            if self._isPlaying {
                self.timer?.invalidate()
                self.timer = nil
            } else {
                self._currentTime = 0
                self.timer = self.createTimer()
            }
            self._isPlaying.toggle()
        }
        
        didReceiveMotion = { [weak self] motion in
            self?._motion = motion
        }
    }
    
    private func createTimer() -> Timer {
        return Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self._currentTime += 0.1
            if self._currentTime >= self._motion.time {
                self.timer?.invalidate()
                self.timer = nil
                self._isPlaying = false
            }
        }
    }
}
