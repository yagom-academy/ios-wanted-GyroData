//
//  FirstModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation

class FirstModel {
    //input
    var didTapMeasureButton: (() -> ()) = { }
    
    //output
    var contentViewModel: FirstListViewModel {
        return privateFirstListViewModel
    }
    
    var routeSubject: (SceneCategory) -> () = { sceneCategory in }
    
    //properties
    private var privateFirstListViewModel: FirstListViewModel
    private var repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
        self.privateFirstListViewModel = FirstListViewModel()
        bind()
    }
    
    private func bind() {
        didTapMeasureButton = { [weak self] in
            guard let self else { return }
            let repository = Repository()
            let model = SecondModel(repository: repository)
            let sceneContext = SceneContext(dependency: model)
            self.routeSubject(.detail(.secondViewController(context: sceneContext)))
        }
        // TODO: 이동 타입(View or Play)을 선택해서 이동하도록 구현해야 함
        privateFirstListViewModel.propagateDidSelectRowEvent = { [weak self] indexPathRow in
            guard let self = self else { return }
            self.routeSubject(.detail(.thirdViewController))
        }
        privateFirstListViewModel.propagateDidSelectPlayActionEvent = { [weak self] indexPathRow in
            guard let self = self else { return }
            self.routeSubject(.detail(.thirdViewController))
        }
    }
    
    func populateData() {
        
    }
}
