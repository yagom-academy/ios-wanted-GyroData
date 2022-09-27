//
//  FirstModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation

class FirstModel: SceneActionReceiver {
    //input
    var didTapMeasureButton: (() -> ()) = { }
    var didReceiveSceneAction: (SceneAction) -> () = { action in }
    
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
//        Task {
//            for _ in 0..<10 {
//                do {
//                    try await DummyGenerator.insertDummyMotionDataToCoreData()
//                } catch {
//                    throw error
//                }
//            }
//        }
        
        // -----
        self.privateFirstListViewModel = FirstListViewModel(motionTasks)
        bind()
    }
    
    private func bind() {
        didTapMeasureButton = { [weak self] in
            guard let self else { return }
            let repository = Repository()
            let motionManager = CoreMotionManager()
            let model = SecondModel(repository: repository, motionManager: motionManager)
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
        privateFirstListViewModel.propagateStartPaging = { [weak self] _ in
            guard let self = self else { return }
            print("!!!!!!!")
            self.populateData()
        }
        
        didReceiveSceneAction = { [weak self] action in
            guard let action = action as? FirstSceneAction else { return }
            guard let self else { return }
            switch action {
            case .refresh:
                self.populateData()
            }
        }
    }
    
    func populateData() {
        Task {
            let motionTasks = try await self.repository.fetchFromCoreData()
            privateFirstListViewModel.didReceiveMotionTasks(motionTasks)
        }
    }
}
