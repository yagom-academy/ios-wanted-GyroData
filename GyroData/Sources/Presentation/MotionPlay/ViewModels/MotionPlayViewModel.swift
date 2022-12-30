//
//  MotionPlayViewModel.swift
//  GyroData
//
//  Created by 우롱차 on 2022/12/28.
//

import Foundation

enum ViewType {
    case play, view
    
    func toTitle() -> String {
        switch self {
        case .play:
            return "Play"
        case .view:
            return "View"
        }
    }
}

enum PlayStatus {
    case stop, play
}

protocol MotionPlayViewModelInput {

    func playStart()
    func playStop()
    
}

protocol MotionPlayViewModelOutput {
    
    var viewType: ViewType { get }
    var motions: Observable<[MotionValue]?> { get }
    var playStatus: Observable<PlayStatus> { get }
    var date: Date { get }
    var duration: Double { get }
    var playMotion: Observable<MotionValue?> { get }
    var playingTime: Observable<Double> { get }
}

protocol MotionPlayViewModel: MotionPlayViewModelInput, MotionPlayViewModelOutput {}

final class DefaultMotionPlayViewModel: MotionPlayViewModel {
        
    var playStatus: Observable<PlayStatus>
    var viewType: ViewType
    var motions: Observable<[MotionValue]?>
    var date: Date
    var duration: Double
    var playMotion: Observable<MotionValue?>
    var playingTime: Observable<Double>
    private var timer = Timer()
    private let motionEntity: MotionEntity
    private var drawingIndex = 0
    
    init(motionEntity: MotionEntity, viewType: ViewType) {
        self.motionEntity = motionEntity
        self.viewType = viewType
        let motionList = try? MotionFileManager.shared.load(by: motionEntity.uuid ?? UUID())
        motions =  Observable(motionList?.values)
        playStatus = Observable(PlayStatus.stop)
        date = motionEntity.date ?? Date()
        duration = motionEntity.duration
        playingTime = .init(0)
        playMotion = .init(nil)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateMotions), userInfo: nil, repeats: true)
    }
    
    @objc func updateMotions() {
        guard let motions = motions.value else {
            return
        }
        if drawingIndex >= motions.count {
            playStop()
        } else {
            playMotion.value = motions[drawingIndex]
            playingTime.value += 0.1
            drawingIndex += 1
        }
    }
    
    func playStart() {
        playStatus.value = .play
        playingTime.value = 0
        startTimer()
    }
    
    func playStop() {
        playStatus.value = .stop
        self.timer.invalidate()
    }
}
