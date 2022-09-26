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
    var motionTasks = [MotionTask]()
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
        // Test 데이터
//        for _ in 0..<10 {
//            CoreDataManager.shared.insertMotionTask(motion: DummyGenerator.getDummyMotionData())
//        }
        
        // -----
        self.privateFirstListViewModel = FirstListViewModel(motionTasks)
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
        Task {
            let motionTasks = try await self.repository.fetchFromCoreData()
            self.privateFirstListViewModel.didReceiveMotionTasks(motionTasks)
        }
    }
}
