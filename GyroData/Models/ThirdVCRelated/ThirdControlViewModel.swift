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
    
    // MARK: Output
    var isPlayingChanged: (Bool) -> () = { isPlaying in } {
        didSet {
            isPlayingChanged(isPlaying)
        }
    }
    var currentTimeChanged: (Double) -> () = { currentTime in } {
        didSet {
            currentTimeChanged(currentTime)
        }
    }
    
    // MARK: Properties
    var isPlaying: Bool = false {
        didSet {
            isPlayingChanged(isPlaying)
        }
    }
    var currentTime: Double = 0 {
        didSet {
            currentTimeChanged(currentTime)
        }
    }
    var timer: Timer?
    
    // MARK: Init
    init() {
        bind()
    }
    
    // MARK: Bind
    func bind() {
        didTapControlButton = { [weak self] in
            guard let self else { return }
            if self.isPlaying {
                self.timer?.invalidate()
                self.timer = nil
            } else {
                self.currentTime = 0
                self.timer = self.createTimer()
            }
            self.isPlaying.toggle()
        }
    }
    
    private func createTimer() -> Timer {
        return Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.currentTime += 0.1
            if self.currentTime >= 60 {
                self.timer?.invalidate()
                self.timer = nil
                self.isPlaying = false
            }
        }
    }
}
