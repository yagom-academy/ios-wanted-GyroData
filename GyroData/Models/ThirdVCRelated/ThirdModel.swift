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
    var viewTypeDidChanged: (ViewType) -> () = { viewType in } {
        didSet {
            viewTypeDidChanged(viewType)
        }
    }
    
    // MARK: Properties
    var infoViewModel: ThirdInfoViewModel
    var controlViewModel: ThirdControlViewModel
    var viewType: ViewType {
        didSet {
            viewTypeDidChanged(viewType)
            infoViewModel.didReceiveViewTypeChanged(viewType)
        }
    }
    
    // MARK: Init
    init(viewType: ViewType) {
        self.viewType = viewType
        self.infoViewModel = ThirdInfoViewModel(viewType: viewType)
        self.controlViewModel = ThirdControlViewModel()
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
