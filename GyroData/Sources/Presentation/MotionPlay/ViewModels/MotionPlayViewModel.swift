//
//  MotionPlayViewModel.swift
//  GyroData
//
//  Created by 곽우종 on 2022/12/28.
//

import Foundation

enum ViewType {
    case play, view
}

protocol PlayViewModelInput {

    func playStart(type: MotionType)
    
}

protocol PlayViewModelOutput {
    
    var viewType: Observable<ViewType> { get }
    var motions: Observable<[MotionValue]?> { get }
    var currentMotion: Observable<MotionValue?> { get }
    
}

protocol PlayViewModel: PlayViewModelInput, PlayViewModelOutput {}

final class DefaultPlayViewModel: PlayViewModel {
    
    let motionEntity: MotionEntity
    
    var viewType: Observable<ViewType>
    
    var motions: Observable<[MotionValue]?>
    
    var currentMotion: Observable<MotionValue?>
    
    init(motionEntity: MotionEntity, viewtype: ViewType) {
        self.motionEntity = motionEntity
        self.viewType = Observable(viewtype)
        let motionList = try? MotionFileManager.shared.load(by: motionEntity.uuid ?? UUID())
        motions =  Observable(motionList?.values)
        currentMotion = Observable(nil)
    }
    
    func playStart(type: MotionType) {
        guard let motions = motions.value else {
            return
        }
        for motion in motions {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.currentMotion.value = motion
            }
        }
    }
}



