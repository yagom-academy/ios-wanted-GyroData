//
//  ThirdModel.swift
//  GyroData
//
//  Created by 한경수 on 2022/09/21.
//
//TODO: 특정 시점에서 graphViewModel이 didReceiveData, didReceiveAll 호출하게끔 추가

import Foundation

class ThirdModel {
    // MARK: Input
    var didTapBackButton: () -> () = { }
    
    // MARK: Output
    var routeSubject: (SceneCategory) -> () = { sceneCategory in }
    var viewTypeSource: (ViewType) -> () = { viewType in } {
        didSet {
            viewTypeSource(_viewType)
        }
    }
    
    // MARK: Properties
    private var repository: RepositoryProtocol
    var infoViewModel: ThirdInfoViewModel
    var controlViewModel: ThirdControlViewModel
    var graphViewModel: GraphViewModel
    private var _viewType: ViewType {
        didSet {
            viewTypeSource(_viewType)
            infoViewModel.didReceiveViewType(_viewType)
        }
    }
    
    private var _motion: MotionTask {
        didSet {
            infoViewModel.didReceiveMotion(_motion)
        }
    }
    
    private var _motionMeasure = [MotionMeasure]() {
        didSet {
            guard _viewType == .view else { return }
            graphViewModel.didReceiveWholePacketData(_motionMeasure)
        }
    }
    
    private var _currentTime: Float = 0 {
        didSet {
            guard _viewType == .play else { return }
            let length = Int(_currentTime * 10)
            graphViewModel.didReceiveTickData(Array(_motionMeasure.prefix(length)))
        }
    }
    
    // MARK: Init
    init(repository: RepositoryProtocol, viewType: ViewType, motion: MotionTask) {
        self.repository = repository
        self._viewType = viewType
        self._motion = motion
        self.infoViewModel = ThirdInfoViewModel(viewType: viewType, motion: motion)
        self.controlViewModel = ThirdControlViewModel(motion: motion)
        self.graphViewModel = GraphViewModel()
        bind()
        Task {
            await fetchMotionMeasures()
        }
    }
    
    // MARK: Bind
    func bind() {
        didTapBackButton = { [weak self] in
            self?.routeSubject(.close)
        }
        
        if _viewType == .play {
            controlViewModel.propagateCurrentTime = { [weak self] currentTime in
                guard let self else { return }
                self._currentTime = currentTime
            }
            
            controlViewModel.propagateIsPlaying = { [weak self] isPlaying in
                guard let self else { return }
                if isPlaying {
                    self.graphViewModel.didReceiveRemoveAll()
                }
            }
        }
    }
    
    // MARK: Private Functions
    @MainActor
    private func fetchMotionMeasures() async {
        do {
            let motionFile = try await repository.fetchFromFileManager(fileName: _motion.path)
            var motionMeasure = [MotionMeasure]()
            motionFile.x_axis.indices.forEach { index in
                let x = Double(motionFile.x_axis[index])
                let y = Double(motionFile.y_axis[index])
                let z = Double(motionFile.z_axis[index])
                motionMeasure.append(MotionMeasure(x: x, y: y, z: z))
            }
            self._motionMeasure = motionMeasure
        } catch let error {
            let okAction = AlertActionDependency(title: "확인")
            let alertDependancy = AlertDependency(title: nil, message: error.localizedDescription, preferredStyle: .alert, actionSet: [okAction])
            self.routeSubject(.alert(alertDependancy))
        }
    }
}

enum ViewType {
    case play
    case view
}
