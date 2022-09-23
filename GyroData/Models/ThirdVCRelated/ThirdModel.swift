//
//  ThirdModel.swift
//  GyroData
//
//  Created by 한경수 on 2022/09/21.
//

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
    var infoViewModel: ThirdInfoViewModel
    var controlViewModel: ThirdControlViewModel
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
    
    // MARK: Init
    init(viewType: ViewType, motion: MotionTask) {
        self._viewType = viewType
        self._motion = motion
        self.infoViewModel = ThirdInfoViewModel(viewType: viewType, motion: motion)
        self.controlViewModel = ThirdControlViewModel(motion: motion)
        bind()
    }
    
    // MARK: Bind
    func bind() {
        didTapBackButton = { [weak self] in
            self?.routeSubject((.close))
        }
    }
}

enum ViewType {
    case play
    case view
}
