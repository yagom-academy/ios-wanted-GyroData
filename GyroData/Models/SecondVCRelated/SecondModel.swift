//
//  SecondModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation
import CoreMotion

class SecondModel {
    // MARK: Input
    var didTapBackButton: () -> () = { }
    var didTapSaveButton: () -> () = { }
    
    // MARK: Output
    var routeSubject: (SceneCategory) -> () = { sceneCategory in }
    var motionMeasuresSource: ([MotionMeasure]) -> () = { measures in } {
        didSet {
            motionMeasuresSource(_motionMeasures)
        }
    }
    
    // MARK: Properties
    private var repository: RepositoryProtocol
    private var motionManager: CoreMotionManagerProtocol
    var segmentViewModel: SecondSegmentViewModel
    var controlViewModel: SecondControlViewModel
    
    private var _motionMeasures = [MotionMeasure]() {
        didSet {
            motionMeasuresSource(_motionMeasures)
        }
    }
    private var _isMeasuring: Bool = false {
        didSet {
            segmentViewModel.didReceiveIsMeasuring(_isMeasuring)
        }
    }
    
    // MARK: Init
    init(repository: RepositoryProtocol, motionManager: CoreMotionManagerProtocol) {
        self.repository = repository
        self.motionManager = motionManager
        self.segmentViewModel = SecondSegmentViewModel()
        self.controlViewModel = SecondControlViewModel()
        bind()
    }
    
    // MARK: Bind
    func bind() {
        didTapBackButton = { [weak self] in
            self?.routeSubject((.close))
        }
        
        didTapSaveButton = { [weak self] in
            guard let self else { return }
            if self._isMeasuring {
                debugPrint("측정 중에는 저장할 수 없습니다.")
                return
            }
            // TODO: 저장 로직 추가..
        }
        
        controlViewModel.propagateDidTapMeasureButton = { [weak self] in
            guard let self else { return }
            let type = self.segmentViewModel.selectedType
            do {
                self._motionMeasures = []
                try self.motionManager.startUpdate(type)
                self._isMeasuring = true
            } catch let error {
                debugPrint(error)
            }
        }
        
        controlViewModel.propagateDidTapStopButton = { [weak self] in
            guard let self else { return }
            let type = self.segmentViewModel.selectedType
            self.motionManager.stopUpdate(type)
            self._isMeasuring = false
        }
        
        motionManager.gyroHandler = { [weak self] data, error in
            guard
                error == nil,
                let data,
                let self
            else { return }
            self._motionMeasures.append(MotionMeasure(data))
            debugPrint(MotionMeasure(data))
        }
        
        motionManager.accHandler = { [weak self] data, error in
            guard
                error == nil,
                let data,
                let self
            else { return }
            self._motionMeasures.append(MotionMeasure(data))
            debugPrint(MotionMeasure(data))
        }
    }
}
