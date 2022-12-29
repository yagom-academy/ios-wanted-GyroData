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
    
}

protocol MotionPlayViewModel: MotionPlayViewModelInput, MotionPlayViewModelOutput {}

final class DefaultMotionPlayViewModel: MotionPlayViewModel {
        
    private let motionEntity: MotionEntity
    var playStatus: Observable<PlayStatus>
    var viewType: ViewType
    var motions: Observable<[MotionValue]?>
    var date: Date
    var duration: Double
    
    init(motionEntity: MotionEntity, viewType: ViewType) {
        self.motionEntity = motionEntity
        self.viewType = viewType
        let motionList = try? MotionFileManager.shared.load(by: motionEntity.uuid ?? UUID())
        motions =  Observable(motionList?.values)
        playStatus = Observable(PlayStatus.stop)
        date = motionEntity.date ?? Date()
        duration = motionEntity.duration
    }
    
    func playStart() {
        playStatus.value = .play
    }
    
    func playStop() {
        playStatus.value = .stop
    }
}



