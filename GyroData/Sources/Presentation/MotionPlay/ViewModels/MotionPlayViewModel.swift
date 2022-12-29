//
//  MotionPlayViewModel.swift
//  GyroData
//
//  Created by 우롱차 on 2022/12/28.
//

import Foundation

enum ViewType {
    case play, view
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
    var currentMotion: Observable<MotionValue?> { get }
    var playStatus: Observable<PlayStatus> { get }
    
}

protocol MotionPlayViewModel: MotionPlayViewModelInput, MotionPlayViewModelOutput {}

final class DefaultPlayViewModel: MotionPlayViewModel {
    
    private let motionEntity: MotionEntity
    var playStatus: Observable<PlayStatus>
    var viewType: ViewType
    var motions: Observable<[MotionValue]?>
    var currentMotion: Observable<MotionValue?>
    
    
    init(motionEntity: MotionEntity, viewtype: ViewType) {
        self.motionEntity = motionEntity
        self.viewType = viewtype
        let motionList = try? MotionFileManager.shared.load(by: motionEntity.uuid ?? UUID())
        motions =  Observable(motionList?.values)
        currentMotion = Observable(nil)
        playStatus = Observable(PlayStatus.stop)
    }
    
    func playStart() {
        playStatus.value = .play
        guard let motions = motions.value else {
            return
        }
        for motion in motions {
            if playStatus.value == .stop {
                break
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.currentMotion.value = motion
            }
        }
    }
    
    func playStop() {
        playStatus.value = .stop
    }
}



