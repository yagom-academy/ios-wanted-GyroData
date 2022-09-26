//
//  SecondModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//
//TODO: 특정 시점에서 graphViewModel이 didReceiveData, didReceiveAll 호출하게끔 추가

import Foundation
import CoreMotion
import UIKit

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
    var isMeasuringSource: (Bool) -> () = { isMeasuring in } {
        didSet {
            isMeasuringSource(_isMeasuring)
        }
    }
    var isLoadingSource: (Bool) -> () = { isLoading in } {
        didSet {
            isLoadingSource(_isLoading)
        }
    }
    
    // MARK: Properties
    private var repository: RepositoryProtocol
    private var motionManager: CoreMotionManagerProtocol
    var segmentViewModel: SecondSegmentViewModel
    var controlViewModel: SecondControlViewModel
    var graphViewModel: GraphViewModel
    
    private var _motionMeasures = [MotionMeasure]() {
        didSet {
            graphViewModel.didReceiveData(_motionMeasures)
            motionMeasuresSource(_motionMeasures)
        }
    }
    private var _isMeasuring: Bool = false {
        didSet {
            isMeasuringSource(_isMeasuring)
            segmentViewModel.didReceiveIsMeasuring(_isMeasuring)
            controlViewModel.didReceiveIsMeasuring(_isMeasuring)
        }
    }
    private var _isLoading: Bool = false {
        didSet {
            isLoadingSource(_isLoading)
        }
    }
    
    // MARK: Init
    init(repository: RepositoryProtocol, motionManager: CoreMotionManagerProtocol) {
        self.repository = repository
        self.motionManager = motionManager
        self.segmentViewModel = SecondSegmentViewModel()
        self.controlViewModel = SecondControlViewModel()
        self.graphViewModel = GraphViewModel()
        bind()
    }
    
    // MARK: Bind
    func bind() {
        didTapBackButton = { [weak self] in
            self?.routeSubject(.close)
        }
        
        didTapSaveButton = { [weak self] in
            guard let self else { return }
            if self._isMeasuring {
                debugPrint("측정 중에는 저장할 수 없습니다.")
                return
            }
            if self._motionMeasures.isEmpty {
                let okAction = AlertActionDependency(title: "확인")
                let alertDependancy = AlertDependency(title: nil, message: "측정된 데이터가 없습니다.", preferredStyle: .alert, actionSet: [okAction])
                self.routeSubject(.alert(alertDependancy))
                return
            }
            self._isLoading = true
            // TODO: 저장 로직 추가..
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self._isLoading = false
                
                let okAction = AlertActionDependency(title: "확인") { _ in
                    self.routeSubject(.close)
                }
                
                let alertDependancy = AlertDependency(title: nil, message: "저장이 완료되었습니다.", preferredStyle: .alert, actionSet: [okAction])
                self.routeSubject(.alert(alertDependancy))
            }
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
