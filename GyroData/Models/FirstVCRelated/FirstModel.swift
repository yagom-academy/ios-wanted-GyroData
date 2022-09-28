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
    var motionTasks = [MotionTask]() {
        didSet {
            privateFirstListViewModel.didReceiveMotionTasks(motionTasks)
        }
    }
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
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
            let model = ThirdModel(repository: self.repository, viewType: .view, motion: motion)
            let context = SceneContext(dependency: model)
            self.routeSubject(.detail(.thirdViewController(context: context)))
        }
        privateFirstListViewModel.propagateDidSelectPlayActionEvent = { [weak self] motion in
            guard let self = self else { return }
            let model = ThirdModel(repository: self.repository, viewType: .play, motion: motion)
            let context = SceneContext(dependency: model)
            self.routeSubject(.detail(.thirdViewController(context: context)))
        }
        privateFirstListViewModel.propagateDidSelectDeleteActionEvent = { [weak self] motion in
            guard let self = self else { return }
            self.removeData(motion: motion)
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
            do {
                self.motionTasks = try await self.repository.fetchFromCoreData()
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func removeData(motion: MotionTask) {
        Task {
            _ = try await self.repository.deleteFromFileManager(fileName: motion.path)
            _ = try await self.repository.deleteFromCoreData(motion: motion)
            self.motionTasks = self.motionTasks.filter { $0.path != motion.path }
        }
    }
    
}
