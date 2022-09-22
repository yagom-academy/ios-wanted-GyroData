//
//  SecondModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation

class SecondModel {
    // MARK: Input
    var didTapBackButton: () -> () = { }
    var didTapSaveButton: () -> () = { }
    
    // MARK: Output
    var routeSubject: (SceneCategory) -> () = { sceneCategory in }
    
    // MARK: Properties
    var segmentViewModel: SecondSegmentViewModel {
        return privateSecondSegmentViewModel
    }
    private var repository: RepositoryProtocol
    private var privateSecondSegmentViewModel: SecondSegmentViewModel
    
    // MARK: Init
    init(repository: RepositoryProtocol) {
        self.repository = repository
        self.privateSecondSegmentViewModel = SecondSegmentViewModel()
        bind()
    }
    
    // MARK: Bind
    func bind() {
        didTapBackButton = { [weak self] in
            self?.routeSubject((.close))
        }
    }
}
