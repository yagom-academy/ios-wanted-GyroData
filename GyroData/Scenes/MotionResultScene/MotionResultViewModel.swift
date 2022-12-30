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
    var error: Observable<String?> { get }
}

protocol MotionResultViewModelType: MotionResultViewModelInput, MotionResultViewModelOutput { }

final class MotionResultViewModel: MotionResultViewModelType {
    private let motionFileManagerUseCase = MotionFileManagerUseCase()
    
    init(_ motion: Motion) {
        self.motionId = motion.id
    }
    
    /// Output
    
    var motionId: UUID?
    var error: Observable<String?> = Observable(nil)
    var motionInformation: Observable<MotionInformation?> = Observable(nil)
    
    /// Input
    
    func load() {
        guard let motionId = motionId else { return }
        motionInformation.value = motionFileManagerUseCase.fetch(motionId) { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                self.error.value = error.errorDescription
            }
        }
    }
    
}
