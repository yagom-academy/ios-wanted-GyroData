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
        // Repository 구현이 끝나면 아래 부분을 Repository에서 MotionTask 배열을 가져오는 방식으로 구현할 예정입니다.
        var motionDatas = [MotionTask]()
        for _ in 0..<50 {
            motionDatas.append(DummyGenerator.getDummyMotionData())
        }
        // -----
        self.privateFirstListViewModel = FirstListViewModel(motionDatas)
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
        privateFirstListViewModel.propagateDidSelectRowEvent = { [weak self] motion in
            guard let self = self else { return }
            let model = ThirdModel(viewType: .view, motion: motion)
            let context = SceneContext(dependency: model)
            self.routeSubject(.detail(.thirdViewController(context: context)))
        }
        privateFirstListViewModel.propagateDidSelectPlayActionEvent = { [weak self] motion in
            guard let self = self else { return }
            let model = ThirdModel(viewType: .play, motion: motion)
            let context = SceneContext(dependency: model)
            self.routeSubject(.detail(.thirdViewController(context: context)))
        }
    }
    
    func populateData() {
        
    }
}
