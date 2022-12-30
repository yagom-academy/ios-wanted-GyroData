//
//  MotionResultViewModel.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/29.
//

import Foundation

protocol MotionResultViewModelInput {
    func load()
}

protocol MotionResultViewModelOutput {
    var motionInformation: Observable<MotionInformation?> { get }
}

protocol MotionResultViewModelType: MotionResultViewModelInput, MotionResultViewModelOutput { }

class MotionResultViewModel: MotionResultViewModelType {
    private let motionFileManagerUseCase = MotionFileManagerUseCase()
    
    init(_ motion: Motion) {
        self.motionId = motion.id
    }
    
    /// Output
    
    var motionId: UUID?
    var motionInformation: Observable<MotionInformation?> = Observable(nil)
    
    /// Input
    
    func load() {
        guard let motionId = motionId else { return }
        motionInformation.value = motionFileManagerUseCase.fetch(motionId)
    }
    
}
